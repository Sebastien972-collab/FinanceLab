//
//  Transaction.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

class Transaction: Identifiable {
    var id = UUID()
    var name : String
    var icon : ImageResource
    var amount : Double
    var date : Date
    var contractor : String
    
    init(id: UUID = UUID(), name: String, icon: ImageResource, amount: Double, date: Date, contractor: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.amount = amount
        self.date = date
        self.contractor = contractor
    }
}
