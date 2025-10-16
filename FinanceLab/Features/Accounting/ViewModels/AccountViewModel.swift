//
//  AccountViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

@Observable
class AccountViewModel {
    
    func saveTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        } else {
            transactions.append(transaction)
        }
    }
    
    func getLatestTransactions() -> [Transaction] {
        return transactions
            .sorted(by: { $0.date > $1.date })
            .prefix(50)
            .map { $0 }
    }
    
    private var transactions: [Transaction] = [
        Transaction(name: "Intérêts", icon: .currencyEurFill, amount: 32.28, date: Date(), contractor: "Caisse d'Épargne"),
        Transaction(name: "Switch 2", icon: .gameControllerFill, amount: -499.99, date: Date(), contractor: "Micromania"),
        Transaction(name: "Essence", icon: .gasPumpFill, amount: -79.82, date: Date(), contractor: "Esso"),
        Transaction(name: "Salaire", icon: .currencyEurFill, amount: 1384.12, date: Date(), contractor: "Evil Corp Inc."),

    ]
}
