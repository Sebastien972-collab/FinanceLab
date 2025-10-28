//
//  Transaction.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

@Observable
class Transaction: Identifiable, Equatable {
    var id: UUID
    var name: String
    var iconName: CategoryIcon
    var amount: Double
    var date: Date
    var contractor: String
    
    init(id: UUID = UUID(), name: String, iconName: CategoryIcon, amount: Double, date: Date, contractor: String) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.amount = amount
        self.date = date
        self.contractor = contractor
    }
    
    func toTransactionData() -> TransactionData {
        TransactionData(
            id: id,
            name: name,
            iconName: iconName.rawValue,
            amount: amount,
            date: date,
            contractor: contractor
        )
    }

    // Ça permet de rendre la Classe Equatable
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.id == rhs.id && lhs.date == rhs.date && lhs.name == rhs.name && lhs.contractor == rhs.contractor && lhs.amount == rhs.amount
    }
}
