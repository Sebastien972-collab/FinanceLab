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
    var spent: Double = 0
    var gained: Double = 0
    
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
    
    func deleteTransaction(_ id: UUID) async {
        do {
            try await service.deleteTransaction(id: id)
        } catch {
            self.error = error
            showError.toggle()
            print("Error deleting a transaction: \(error)")
        }
    }
    
    func calcSpendingRepartition() {
        // Gets only the transactions from current month
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let monthlyTransactions = transactionsList.filter { transac in
            let transacMonth = Calendar.current.component(.month, from: transac.date)
            let transacYear = Calendar.current.component(.year, from: transac.date)
            return transacMonth == currentMonth && transacYear == currentYear
        }

        // Return the sum of all negative transactions in the array (as an absolute)
        spent = 0
        for transac in monthlyTransactions {
            if transac.amount < 0 {
                spent += -transac.amount
            }
        }
        
        // Return the sum of all positive transactions in the array (as an absolute)
        gained = 0
        for transac in monthlyTransactions {
            if transac.amount > 0 {
                gained += transac.amount
            }
        }
    }
}
