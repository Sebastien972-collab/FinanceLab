//
//  User.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 30/09/2025.
//

import Foundation
import FinanceCore

class User: Identifiable, Decodable {
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
    static var preview: User {
        let user: User = .init(firstName: "Sébastien", lastName: "DAGUIN", email: "certifieddev@finance.com")
        user.profilePictureUrl = "https://media.istockphoto.com/id/965206748/fr/photo/toujours-profiter-à-des-promenades-imprudents.jpg?s=1024x1024&w=is&k=20&c=uMVZdiZB6OglGI4SY4s7fHAUmpXITOg3VA5PCstZ5do="
        return user
    }
}
