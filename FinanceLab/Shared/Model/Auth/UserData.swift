//
//  UserData.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

/// Structure représentant la réponse JSON venant du serveur Vapor
struct UserData: Decodable {
    let id: UUID
    let firstName: String
    let lastName: String
    let userCategory: String
    let profilePictureURL: String
    let email: String
    let balance: Double
    
    /// Convertit le DTO en objet `User` utilisable dans l’app
    func toUser() -> User {
        let user = User(
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        user.profilePictureUrl = self.profilePictureURL
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
