//
//  User.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 30/09/2025.
//

import Foundation
import FinanceCore

class User: Identifiable {
    private(set) var id: UUID = UUID()
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var email: String
    var displayName: String { "\(self.firstName) \(self.lastName)" }
    var dateOfRegistration: Date = Date()
    var balance: Decimal = 0.00
    var profilePictureUrl: String?
    
    init(firstName: String, lastName: String, email: String, profilePictureUrl: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePictureUrl = profilePictureUrl
    }
    
    convenience init(firstName: String, lastName: String, email: String, dateOfRegistration: Date, balance: Decimal, profilePictureUrl: String? = nil ) {
        self.init(firstName: firstName, lastName: lastName, email: email, profilePictureUrl: profilePictureUrl)
        self.dateOfRegistration = dateOfRegistration
        self.balance = balance
    }
}

extension User {
    static var guest: User {
        .init(firstName: "Visiteur", lastName: "Anonyme", email: "visiteur@finance.com")
    }
}
