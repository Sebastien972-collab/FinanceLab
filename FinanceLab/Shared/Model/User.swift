//
//  User.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 30/09/2025.
//

import Foundation
import FinanceCore

@Observable
class Customer: Identifiable {
    let id: UUID
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var email: String
    var displayName: String { "\(self.firstName) \(self.lastName)" }
    var dateOfRegistration: Date = Date()
    var balance: Decimal = 0.00
    var monthlyRevenue: Decimal = 0.00
    var monthlyExpenses: Decimal = 0.00
    var profilePictureUrl: String?
    var transactions: [Transaction] = []
    var answers: [Answer] = []
    var projects: [Project] = []
    var userCategory: FinancialProfile = .none
    init(id: UUID = UUID(), firstName: String, lastName: String, email: String, profilePictureUrl: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePictureUrl = profilePictureUrl
    }
    
    convenience init(firstName: String, lastName: String, email: String, dateOfRegistration: Date, balance: Decimal, profilePictureUrl: String? = nil, transaction: [Transaction] = []) {
        self.init(firstName: firstName, lastName: lastName, email: email, profilePictureUrl: profilePictureUrl)
        self.dateOfRegistration = dateOfRegistration
        self.balance = balance
        self.transactions =  transaction
    }
    
    func addTransaction(_ transaction: Transaction) {
        guard !transactions.contains(where: { $0.id == transaction.id }) else { return }
        transactions.append(transaction)
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }
    
    func removeTransaction(_ transaction: Transaction) {
        removeTransaction(withId: transaction.id)
    }

    func removeTransaction(withId id: UUID) {
        transactions.removeAll { $0.id == id }
    }

    func applyFinancialSummary(_ summary: FinancialProfileSummary) {
        monthlyRevenue = summary.monthlyRevenue
        monthlyExpenses = summary.monthlyExpenses
        userCategory = summary.profile
    }
}

extension Customer: Equatable {
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        lhs.id == rhs.id && lhs.email == rhs.email
    }
    
    
    
    
    static var guest: Customer {
        .init(firstName: "Visiteur", lastName: "Anonyme", email: "visiteur@finance.com")
    }
    static var preview: Customer {
        let user: Customer = .init(firstName: "Sébastien", lastName: "DAGUIN", email: "certifieddev@finance.com")
        user.profilePictureUrl = "https://media.istockphoto.com/id/965206748/fr/photo/toujours-profiter-à-des-promenades-imprudents.jpg?s=1024x1024&w=is&k=20&c=uMVZdiZB6OglGI4SY4s7fHAUmpXITOg3VA5PCstZ5do="
        return user
    }
    
    func getToken() {
       
    }
    
    func toUserData() -> UserData {
        UserData(
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            userCategory: self.userCategory.rawValue,
            profilePictureURL: self.profilePictureUrl ?? "",
            email: self.email,
            balance: self.balance.toDoucble(),
            monthlyRevenue: self.monthlyRevenue.toDoucble(),
            monthlyExpenses: self.monthlyExpenses.toDoucble()
        )
    }
}
