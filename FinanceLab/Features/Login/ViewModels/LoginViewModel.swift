//
//  LoginViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 16/10/2025.
//  Refactored by Gemini (Architecture Expert) 2026
//

import Foundation
import SwiftUI


@MainActor
@Observable
class LoginViewModel {
    
    // MARK: - Inputs
    var pickerSelected: Int = 0 {
        didSet { clearErrors() }
    }
    var email: String = ""
    var password: String = ""
    var passwordConfirmation: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    // MARK: - State
    var isLoading: Bool = false
    var showError: Bool = false
    var error: Error = LoginError.unknown
    
    // MARK: - Computed Properties
    var isSignUp: Bool {
        pickerSelected == 1
    }
    
    var passwordStrength: PasswordStrength {
        let pwd = password
        if pwd.isEmpty { return .veryWeak }
        if pwd.count < 6 { return .veryWeak }
        
        var score = 1
        if pwd.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "\\d", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "[@$#!%*?&._-]", options: .regularExpression) != nil { score += 1 }
        if pwd.count >= 12 { score += 1 }

        switch score {
        case 1: return .veryWeak
        case 2: return .weak
        case 3: return .medium
        case 4: return .strong
        default: return .veryStrong
        }
    }
    
    // MARK: - Dependencies
    private let manager: CustomerManager = .shared
    // MARK: - Actions

    func login(onSuccess: () -> Void) async {
        guard await performAction(action: {
            try validateInputs()
            try await manager.login(email: email, password: password)
            onSuccess()
        }) else {
            self.error = error
            self.showError = true
            return
        }
    }
    
    func create(onSuccess: () -> Void) async {
        guard await performAction(action: {
            try validateInputs()
            try await manager.create(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
        }) else { return }
        
        onSuccess()
    }

    func fetchUser() async {
        _ = await performAction {
            try await manager.fetchProfile()
        }
    }
    
    // MARK: - Private Helpers
    
    /// Exécute une action asynchrone avec gestion d'erreur et loading state centralisés
    private func performAction(action: () async throws -> Void) async -> Bool {
        isLoading = true
        clearErrors()
        defer { isLoading = false }
        
        do {
            try await action()
            return true
        } catch {
            self.error = error
            self.showError = true
            return false
        }
    }
    
    private func clearErrors() {
        showError = false
    }

    // MARK: - Validation Logic
    
    private func validateInputs() throws {
        if email.isEmpty || password.isEmpty {
            throw LoginError.emptyFields
        }
        if isSignUp {
            if firstName.isEmpty || lastName.isEmpty || passwordConfirmation.isEmpty {
                throw LoginError.emptyFields
            }
            if password != passwordConfirmation {
                throw LoginError.differentPasswords
            }
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            throw LoginError.invalidEmail
        }
        
        // 4. Format Mot de passe (min 6 chars)
        if password.count < 6 {
            throw LoginError.invalidPassword
        }
    }
}
