//
//  UserData.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

/// Structure représentant la réponse JSON venant du serveur Vapor
struct UserData: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let userCategory: String
    let profilePictureURL: String
    let email: String
    let balance: Double
    
    /// Convertit le DTO en objet `User` utilisable dans l’app
    func toUser() -> Customer {
        let user = Customer(
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        user.profilePictureUrl = self.profilePictureURL
        user.balance = Decimal(self.balance)
        return user
    }
}

struct PatchedUserData: Decodable {
    var firstName: String?
    var lastName: String?
    var userCategory: String?
    var profilePictureURL: String?
    var email: String?
    var balance: Double?
}
