//
//  TransactionData.swift
//  FinanceLab
//
//  Created by Anne Ferret on 28/10/2025.
//

import SwiftUI

struct TransactionData: Identifiable, Equatable, Codable {
    var id: UUID
    var name: String
    var iconName: String
    var amount: Double
    var date: Date?
    var contractor: String
    
    init(id: UUID = UUID(), name: String, iconName: String, amount: Double, date: Date, contractor: String) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.amount = amount
        self.date = date
        self.contractor = contractor
    }
    
    func toTransaction() -> Transaction {
        Transaction(
            id: id,
            name: name,
            iconName: CategoryIcon(rawValue: iconName) ?? CategoryIcon.selectionFill,
            amount: amount,
            date: date ?? Date(),
            contractor: contractor
        )
    }
    
    // Ça permet de rendre la Classe Equatable
    static func == (lhs: TransactionData, rhs: TransactionData) -> Bool {
        lhs.id == rhs.id &&
        lhs.date == rhs.date &&
        lhs.name == rhs.name &&
        lhs.contractor == rhs.contractor &&
        lhs.amount == rhs.amount &&
        lhs.iconName == rhs.iconName  // Added this line
    }
}
