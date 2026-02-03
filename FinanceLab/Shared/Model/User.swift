//
//  User.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 30/09/2025.
//

import Foundation
import FinanceCore

class Customer: Identifiable {
    private(set) var id: UUID = UUID()
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var email: String
    var displayName: String { "\(self.firstName) \(self.lastName)" }
    var dateOfRegistration: Date = Date()
    var balance: Decimal = 0.00
    var profilePictureUrl: String?
    var transactions: [Transaction] = []
    var answers: [Answer] = []
    var projects: [Project] = []
    var userCategory: FinancialProfile = .none
    init(firstName: String, lastName: String, email: String, profilePictureUrl: String? = nil) {
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
        guard transactions.contains(transaction) else { return }
        transactions.append(transaction)
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(of: transaction) {
            transactions[index] = transaction
        }
    }
    
    func removeTransaction(_ transaction: Transaction) {
        guard transactions.contains(transaction) else { return }
        transactions.removeAll { $0 == transaction }
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
        UserData(id: self.id, firstName: self.firstName, lastName: self.lastName, userCategory: self.userCategory.rawValue, profilePictureURL: self.profilePictureUrl ?? "", email: self.email, balance: self.balance.toDoucble())
    }
}
