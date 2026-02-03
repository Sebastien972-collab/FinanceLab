//
//  TransactionService.swift
//  FinanceLab
//
//  Created by Anne Ferret on 28/10/2025.
//  Refactored by Sébastien DAGUIN (Backend Expert) 2026
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class TransactionService {
    
    static let shared = TransactionService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Helpers
    
    /// Récupère l'ID utilisateur courant ou lance une erreur
    private var currentUserId: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Utilisateur non connecté"])
            }
            return uid
        }
    }
    
    // MARK: - CRUD
    
    /// Récupère toutes les transactions de l'utilisateur triées par date
    func fetchTransactions() async throws -> [Transaction] {
        let uid = try currentUserId
        
        let snapshot = try await db.collection("users").document(uid)
            .collection("transactions")
            .order(by: "date", descending: true)
            .getDocuments()
        
        // Mapping des documents Firestore vers votre modèle Transaction
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: TransactionData.self)
        }.map { $0.toTransaction() }
    }
    
    /// Crée une transaction et met à jour le solde (Batch Write)
    func postTransaction(transaction: TransactionData) async throws {
        let uid = try currentUserId
        
        let userRef = db.collection("users").document(uid)
        let newDocRef = userRef.collection("transactions").document() // ID Auto
        
        // On injecte l'ID généré dans l'objet avant l'envoi
        var newTransaction = transaction
        newTransaction.id = UUID(uuidString: newDocRef.documentID) ?? UUID()
        
        let batch = db.batch()
        
        // 1. Création du document transaction
        try batch.setData(from: newTransaction, forDocument: newDocRef)
        
        // 2. Mise à jour atomique du solde
        batch.updateData([
            "balance": FieldValue.increment(transaction.amount),
            "lastUpdate": FieldValue.serverTimestamp()
        ], forDocument: userRef)
        
        try await batch.commit()
    }
    
    /// Modifie une transaction existante et ajuste le solde (Firestore Transaction)
    func putTransaction(transaction: TransactionData) async throws {
        let uid = try currentUserId
        let transactionId = transaction.id
        
        let userRef = db.collection("users").document(uid)
        let transactionRef = userRef.collection("transactions").document(transactionId.uuidString)
        
        // Utilisation d'une transaction Firestore (RunTransaction)
        // Nécessaire pour lire l'ancien montant AVANT de calculer la différence
        try await db.runTransaction({ (ctx, errorPointer) -> Any? in
            do {
                // A. Lire l'ancienne transaction
                let oldDoc = try ctx.getDocument(transactionRef)
                guard let oldAmount = oldDoc.data()?["amount"] as? Double else {
                    return nil
                }
                
                // B. Calculer la différence (Nouveau - Ancien)
                let difference = transaction.amount - oldAmount
                
                // C. Écrire la nouvelle transaction
                try ctx.setData(from: transaction, forDocument: transactionRef)
                
                // D. Mettre à jour le solde avec la différence
                ctx.updateData([
                    "balance": FieldValue.increment(difference),
                    "lastUpdate": FieldValue.serverTimestamp()
                ], forDocument: userRef)
                
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        })
    }
    
    /// Supprime une transaction et rembourse/déduit le solde (Firestore Transaction)
    func deleteTransaction(id: UUID) async throws {
        // Note : Firestore utilise des String ID, conversion UUID -> String
        let uid = try currentUserId
        let transactionId = id.uuidString
        
        let userRef = db.collection("users").document(uid)
        let transactionRef = userRef.collection("transactions").document(transactionId)
        
        try await db.runTransaction({ (ctx, errorPointer) -> Any? in
            do {
                // A. Lire le montant avant suppression
                let doc = try ctx.getDocument(transactionRef)
                guard let amountToDelete = doc.data()?["amount"] as? Double else {
                    return nil
                }
                
                // B. Supprimer le document
                ctx.deleteDocument(transactionRef)
                
                // C. Inverser l'impact sur le solde (ex: si c'était -50, on fait -(-50) = +50)
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
