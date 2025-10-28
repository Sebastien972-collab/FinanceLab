//
//  AccountViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

@Observable
class AccountViewModel {
    // Services
    var manager: UserManager = .shared
    var service = TransactionService()
    
    // Affichage d'un message d'erreur explicite
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // Variables affichées dans les vues
    var transactionsList: [Transaction] = []
    
    // Fonctions CRUD
    
    func fetchTransactions() async {
        do {
            transactionsList = try await service.fetchTransactions()
                .sorted(by: { $0.date > $1.date })
        } catch {
            self.error = error
            showError.toggle()
            print("Error fetching transactions: \(error)")
        }
    }
    
    func postTransaction(_ transaction: Transaction) async {
        do {
            try await service.postTransaction(transaction: transaction.toTransactionData())
        } catch {
            self.error = error
            showError.toggle()
            print("Error posting a new transaction: \(error)")
        }
    }
    
    func putTransaction(_ transaction: Transaction) async {
        do {
            try await service.putTransaction(transaction: transaction.toTransactionData())
        } catch {
            self.error = error
            showError.toggle()
            print("Error updating a transaction: \(error)")
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions.remove(at:index)
        }
    }
    
    private var transactions: [Transaction] = [
        Transaction(name: "Intérêts", iconName: .currencyEurFill, amount: 32.28, date: Date(), contractor: "Caisse d'Épargne"),
        Transaction(name: "Switch 2", iconName: .gameControllerFill, amount: -499.99, date: Date(), contractor: "Micromania"),
        Transaction(name: "Essence", iconName: .gasPumpFill, amount: -79.82, date: Date(), contractor: "Esso"),
        Transaction(name: "Salaire", iconName: .currencyEurFill, amount: 1384.12, date: Date(), contractor: "Evil Corp Inc."),
    ]
}
