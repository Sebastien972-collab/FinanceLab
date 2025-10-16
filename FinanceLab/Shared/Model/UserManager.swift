//
//  UserManager.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 14/10/2025.
//

import Foundation

class UserManager {
    private let service: UserService = .shared
    private(set) var currentUser: User = .guest
    var isLoggedIn: Bool {
        currentUser != .guest
    }
    func create(email: String, password: String) async throws -> User {
        do {
            self.currentUser = try await service.create(email: email, password: password)
            return currentUser
        } catch  {
            throw error
        }
    }
    ///Login user
    func login(email: String, password: String) async throws -> User {
        do {
            return try await service.login(email: email, password: password)
        } catch  {
            throw error
        }
    }
    
    func upadateUser(_ newUser: User) {
        self.currentUser = newUser
    }
    
    func logout() {
        self.currentUser = .guest
    }
}
