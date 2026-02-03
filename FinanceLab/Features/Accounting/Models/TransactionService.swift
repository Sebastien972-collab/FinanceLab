//
//  TransactionService.swift
//  FinanceLab
//
//  Created by Anne Ferret on 28/10/2025.
//  Refactored by Gemini (Backend Expert) 2026
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FinanceCore // Assurez-vous que vos modèles sont ici

/// Enum pour filtrer facilement les requêtes
enum TransactionFilter {
    case all
    case expenses // Dépenses (< 0)
    case incomes  // Revenus (> 0)
}

final class TransactionService {
    
    static let shared = TransactionService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Helpers
    
    /// Récupère l'ID de l'utilisateur connecté de manière sécurisée
    private var currentUserId: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Utilisateur non connecté"])
            }
            return uid
        }
    }
    
    // MARK: - 1. READ (Lire)
    
    /// Récupère les transactions avec un filtre optionnel (Tout, Dépenses, Revenus)
    func fetchTransactions(filter: TransactionFilter = .all) async throws -> [Transaction] {
        let uid = try currentUserId
        
        // On cible la sous-collection "transactions" du user
        var query: Query = db.collection("users").document(uid)
            .collection("transactions")
        
        // Application du filtre serveur (C'est Firestore qui trie, pas l'iPhone)
        switch filter {
        case .all:
            break // Pas de filtre
        case .expenses:
            query = query.whereField("amount", isLessThan: 0)
        case .incomes:
            query = query.whereField("amount", isGreaterThan: 0)
        }
        
        // Tri par date (du plus récent au plus ancien)
        // Note: Si vous utilisez un filtre, Firestore demandera peut-être un Index Composite (lien dans la console)
        query = query.order(by: "date", descending: true)
        
        let snapshot = try await query.getDocuments()
        
        // Conversion sécurisée des documents en objets Swift
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: TransactionData.self)
        }.map { $0.toTransaction() }
    }
    
    // MARK: - 2. CREATE (Créer)
    
    /// Ajoute une transaction et met à jour le solde (Atomicité via Batch)
    func postTransaction(transaction: Transaction) async throws {
        let uid = try currentUserId
        
        let userRef = db.collection("users").document(uid)
        let newDocRef = userRef.collection("transactions").document() // ID Auto
        
        // On assigne l'ID généré par Firestore à l'objet pour qu'ils soient identiques
        let newTransaction = transaction
        newTransaction.id = UUID(uuidString: newDocRef.documentID) ?? UUID()
        
        let batch = db.batch()
        
        // A. Créer la transaction
        try batch.setData(from: newTransaction.toTransactionData(), forDocument: newDocRef)
        
        // B. Mettre à jour le solde global
        batch.updateData([
            "balance": FieldValue.increment(transaction.amount),
            "lastUpdate": FieldValue.serverTimestamp()
        ], forDocument: userRef)
        
        // C. Tout envoyer d'un coup
        try await batch.commit()
    }
    
    // MARK: - 3. UPDATE (Modifier)
    
    /// Modifie une transaction et ajuste le solde selon la différence (Firestore Transaction)
    func putTransaction(transaction: Transaction) async throws {
        let uid = try currentUserId
        let transactionId = transaction.id.uuidString
        
        let userRef = db.collection("users").document(uid)
        let transactionRef = userRef.collection("transactions").document(transactionId)
        
        // Utilisation d'une Transaction Firestore pour lire l'ancienne valeur avant d'écrire
        _ = try await db.runTransaction({ (ctx, errorPointer) -> Any? in
            do {
                // A. Lire l'ancienne transaction pour avoir l'ancien montant
                let oldDoc = try ctx.getDocument(transactionRef)
                
                guard let oldAmount = oldDoc.data()?["amount"] as? Double else {
                    return nil // Le document n'existe plus
                }
                
                // B. Calculer l'impact sur le solde (Nouveau - Ancien)
                // Ex: Je passe de -50€ (ancien) à -20€ (nouveau). Différence = +30€.
                let difference = transaction.amount - oldAmount
                
                // C. Écrire la nouvelle version de la transaction
                try ctx.setData(from: transaction.toTransactionData(), forDocument: transactionRef)
                
                // D. Ajuster le solde
                ctx.updateData([
                    "balance": FieldValue.increment(difference),
                    "lastUpdate": FieldValue.serverTimestamp()
                ], forDocument: userRef)
                
                return nil
            } catch let nsError as NSError {
                errorPointer?.pointee = nsError
                return nil
            }
        })
    }
    
    // MARK: - 4. DELETE (Supprimer)
    
    /// Supprime une transaction et rembourse son impact sur le solde
    func deleteTransaction(id: UUID) async throws {
        let uid = try currentUserId
        let transactionId = id.uuidString
        
        let userRef = db.collection("users").document(uid)
        let transactionRef = userRef.collection("transactions").document(transactionId)
        
        _ = try await db.runTransaction({ (ctx, errorPointer) -> Any? in
            do {
                // A. Lire le montant avant de supprimer pour savoir quoi rembourser
                let doc = try ctx.getDocument(transactionRef)
                
                guard let amountToDelete = doc.data()?["amount"] as? Double else {
                    return nil
                }
                
                // B. Supprimer la transaction
                ctx.deleteDocument(transactionRef)
                
                // C. Inverser l'impact sur le solde
                // Si c'était une dépense de -50, on fait -(-50) = +50 (remboursement)
                // Si c'était un revenu de +1000, on fait -(1000) = -1000 (annulation)
                ctx.updateData([
                    "balance": FieldValue.increment(-amountToDelete),
                    "lastUpdate": FieldValue.serverTimestamp()
                ], forDocument: userRef)
                
                return nil
            } catch let nsError as NSError {
                errorPointer?.pointee = nsError
                return nil
            }
        })
    }
}
