import Foundation
import FirebaseAuth
import FirebaseFirestore

struct TransactionPage {
    let items: [Transaction]
    let next: DocumentSnapshot?
}

final class TransactionService {
    static let shared = TransactionService()
    private init() {}

    private var db: Firestore { Firestore.firestore() }

    private func userDocument() throws -> DocumentReference {
        guard let uid = Auth.auth().currentUser?.uid else { throw LoginError.unknown }
        return db.collection("users").document(uid)
    }

    func recentTransactions(since date: Date) async throws -> [Transaction] {
        let snapshot = try await userDocument().collection("transactions")
            .whereField("date", isGreaterThanOrEqualTo: date)
            .order(by: "date", descending: true).getDocuments()
        return try snapshot.documents.map { try $0.data(as: TransactionData.self).toTransaction() }
    }

    func history(before date: Date, after cursor: DocumentSnapshot?) async throws -> TransactionPage {
        let pageSize = 50
        var query = try userDocument().collection("transactions")
            .whereField("date", isLessThan: date).order(by: "date", descending: true)
        if let cursor { query = query.start(afterDocument: cursor) }
        let documents = try await query.limit(to: pageSize).getDocuments().documents
        return TransactionPage(
            items: try documents.map { try $0.data(as: TransactionData.self).toTransaction() },
            next: documents.count == pageSize ? documents.last : nil
        )
    }

    func postTransaction(transaction: Transaction, projectID: UUID? = nil) async throws -> Decimal? {
        try await commit(.create, id: transaction.id, entry: transaction, projectID: projectID)
    }

    func putTransaction(transaction: Transaction) async throws {
        _ = try await commit(.edit, id: transaction.id, entry: transaction)
    }

    func deleteTransaction(id: UUID) async throws {
        _ = try await commit(.delete, id: id)
    }

    /// Return the committed savings total when the entry belongs to a project.
    /// The callback can be retried by Firestore. Only update UI state after commit.
    private func commit(_ operation: LedgerChange, id: UUID, entry: Transaction? = nil,
                        projectID: UUID? = nil) async throws -> Decimal? {
        let user = try userDocument()
        let document = user.collection("transactions").document(id.uuidString)
        let fields = try entry.map { try Firestore.Encoder().encode($0.toTransactionData()) }
        let proposed = Decimal(entry?.amount ?? 0)
        let requestedProject = projectID?.uuidString
        let result = try await db.runTransaction { @Sendable context, failure -> Any? in
            do {
                let existing = try context.getDocument(document)
                let profile = try context.getDocument(user)
                guard let balance = profile.get("balance") as? NSNumber else {
                    throw LoginError.custom("Impossible de lire le solde du compte.")
                }
                let previous = existing.get("amount") as? NSNumber
                if existing.exists && previous == nil {
                    throw LoginError.custom("Le montant enregistré est illisible.")
                }
                let linkedProject = existing.get("projectID") as? String
                let project = (linkedProject ?? requestedProject).map { user.collection("projects").document($0) }
                let projectSnapshot = try project.map { try context.getDocument($0) }
                let saved = projectSnapshot?.get("amountSaved") as? NSNumber
                var receipt: [String: Double] = ["balance": balance.doubleValue]
                if let saved { receipt["saved"] = saved.doubleValue }

                guard let delta = try operation.adjustment(previous: previous?.decimalValue, proposed: proposed,
                                                           linkedProject: linkedProject, requestedProject: requestedProject) else {
                    return receipt
                }

                if let project, let projectSnapshot, projectSnapshot.exists {
                    guard let saved else { throw LoginError.custom("Le montant de la cagnotte est illisible.") }
                    let newSavings = try LedgerChange.savings(after: delta, previous: saved.decimalValue, entry: proposed)
                    let total = NSDecimalNumber(decimal: newSavings).doubleValue
                    context.updateData(["amountSaved": total], forDocument: project)
                    receipt["saved"] = total
                } else if requestedProject != nil {
                    throw LoginError.custom("Cette cagnotte a été supprimée.")
                }

                if var fields {
                    if let linked = requestedProject ?? linkedProject { fields["projectID"] = linked }
                    context.setData(fields, forDocument: document)
                } else {
                    context.deleteDocument(document)
                }
                let newBalance = NSDecimalNumber(decimal: balance.decimalValue + delta).doubleValue
                context.updateData(["balance": newBalance, "lastUpdate": FieldValue.serverTimestamp()], forDocument: user)
                receipt["balance"] = newBalance
                return receipt
            } catch {
                failure?.pointee = error as NSError
                return nil
            }
        }

        guard Auth.auth().currentUser?.uid == user.documentID else { throw CancellationError() }
        guard let receipt = result as? [String: NSNumber], let balance = receipt["balance"] else {
            throw LoginError.custom("La confirmation du solde est indisponible.")
        }
        CustomerManager.shared.currentUser.balance = balance.decimalValue
        return receipt["saved"]?.decimalValue
    }
}
