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
        Transaction(name: "Switch 2", icon: .gameControllerFill, amount: -499.99, date: Date(), contractor: "Micromania"),
        Transaction(name: "Essence", icon: .gasPumpFill, amount: -79.82, date: Date(), contractor: "Esso"),
        Transaction(name: "Salaire", icon: .currencyEurFill, amount: 1384.12, date: Date(), contractor: "Evil Corp Inc."),

    ]
}
