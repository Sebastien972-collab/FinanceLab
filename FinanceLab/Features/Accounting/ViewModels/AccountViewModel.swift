//
//  AccountViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

@Observable
class AccountViewModel {
    
    var editingTransaction: Transaction?
        
    func setNewTransaction() {
        let newTransaction = Transaction(
            name: "",
            icon: .selectionFill,
            amount: 0.0,
            date: Date(),
            contractor: ""
        )
        transactions.insert(newTransaction, at: 0)
        editingTransaction = newTransaction
    }
        
    func saveTransaction(_ transaction: Transaction) {
        editingTransaction = nil
    }
    
    func getLatestTransactions() -> [Transaction] {
        return transactions
            .sorted(by: { $0.date > $1.date })
            .prefix(50)
            .map { $0 }
    }
    
    private var transactions: [Transaction] = [
        Transaction(name: "Intérêts", icon: .bankFill, amount: 32.28, date: Date(), contractor: "Caisse d'Épargne"),
    ]
}
