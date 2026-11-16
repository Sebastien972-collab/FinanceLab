//
//  UserData.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation
import FinanceCore

/// Structure représentant la réponse JSON venant du serveur Vapor
struct UserData: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let userCategory: String
    let profilePictureURL: String
    let email: String
    let balance: Double
    let monthlyRevenue: Double?
    let monthlyExpenses: Double?
    
    /// Convertit le DTO en objet `User` utilisable dans l’app
    func toUser() -> Customer {
        let user = Customer(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        user.profilePictureUrl = self.profilePictureURL
        user.balance = Decimal(self.balance)
        user.monthlyRevenue = Decimal(monthlyRevenue ?? 0)
        user.monthlyExpenses = Decimal(monthlyExpenses ?? 0)
        if let parsedProfile = FinancialProfile.allCases.first(where: {
            $0.rawValue.compare(userCategory, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }) {
            user.userCategory = parsedProfile
        }
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
    var monthlyRevenue: Double?
    var monthlyExpenses: Double?
}
