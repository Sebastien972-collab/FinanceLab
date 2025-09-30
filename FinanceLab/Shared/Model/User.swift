//
//  User.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 30/09/2025.
//

import Foundation
import FinanceCore

class User: Identifiable {
    private(set)var id: UUID = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var displayName: String { "\(self.firstName) \(self.lastName)" }
    var dateOfRegistration: Date = Date()
    var balance: Decimal = 0.00
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    convenience init(firstName: String, lastName: String, email: String, dateOfRegistration: Date, balance: Decimal) {
        self.init(firstName: firstName, lastName: lastName, email: email)
        self.dateOfRegistration = dateOfRegistration
        self.balance = balance
    }
}
