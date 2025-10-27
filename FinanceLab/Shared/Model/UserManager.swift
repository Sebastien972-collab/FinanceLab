//
//  UserManager.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 14/10/2025.
//

import Foundation

class UserManager {
    static let shared: UserManager = .init()
    private init () {}
    private let service: UserService = .shared
    private(set) var currentUser: User = .guest
    var isLoggedIn: Bool {
        currentUser != .guest
    }
    func create(firstName: String, lastName: String, email: String, password: String) async throws {
        do {
            self.currentUser = try await service.create(firstName: firstName, lastName: lastName, email: email, password: password)
        } catch  {
            throw error
        }
    }
    ///Login user
    func login(email: String, password: String) async throws {
        do {
            self.currentUser = try await service.login(email: email, password: password)
        } catch  {
            throw error
        }
    }
    
    func fetchProfile() async throws {
        self.currentUser =  try await service.fetchProfile()
    }
    
    func upadateUser(_ newUser: User) {
        self.currentUser = newUser
    }
    
    func logout() {
        self.currentUser = .guest
    }
}
