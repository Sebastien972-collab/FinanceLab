//
//  AuthManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/02/2026.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    var isAuth: Bool { Auth.auth().currentUser != nil }
    private var auth: Auth { Auth.auth() }
    
    func signUp(withEmail email: String, password: String) async throws -> AuthDataResult {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func logout() throws {
        try auth.signOut()
    }
}
