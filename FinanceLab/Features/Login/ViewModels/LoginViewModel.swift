//
//  LoginViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 16/10/2025.
//

import Foundation

@Observable
class LoginViewModel {
    var pickerSelected: Int = 0
    var email: String = ""
    var password: String = ""
    var passwordConfirmation: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var manager: UserManager = .shared
    var error: Error = LoginError.unknown
    var showError: Bool = false
    var isWorking: Bool = false

    func login(callback: (() -> Void)? = nil) async {
        isWorking = true
        defer { isWorking = false }
        guard checkField() else { return }
        
        do {
            try await manager.login(email: email, password: password)
            if let callback = callback {
                await MainActor.run { callback() }
            }
        } catch let err {
            self.error = err
            self.showError = true
        }
    }
    
    func create(callback: (() -> Void)? = nil) async {
        isWorking = true
        defer { isWorking = false }
        guard checkField() else { return }
        
        do {
            try await manager.create(firstName: firstName, lastName: lastName, email: email, password: password)
            if let callback = callback {
                await MainActor.run { callback() }
            }
        } catch let err {
            self.error = err
            self.showError = true
        }
    }

    func fetchUser() async {
        do {
            try await manager.fetchProfile()
        } catch let err {
            self.error = err
            self.showError = true
        }
    }

    @discardableResult
    private func checkField() -> Bool {
        if pickerSelected == 0 {
            guard !email.isEmpty && !password.isEmpty else {
                failValidation()
                return false
            }
            guard email.isValidEmail, password.isValidPassword else {
                failValidation()
                return false
            }
        } else {
            guard !email.isEmpty,
                  !password.isEmpty,
                  !passwordConfirmation.isEmpty,
                  !firstName.isEmpty,
                  !lastName.isEmpty else {
                failValidation()
                return false
            }
            
        }
        guard checkEmailAndPassword() else { return false }
        return true
    }
    
    private func failValidation(withError error: Error = LoginError.emptyFields) {
        isWorking = false
        self.error = error
        self.showError = true
    }
    
    private func checkEmailAndPassword() -> Bool {
        guard email.isValidEmail else {
            failValidation(withError: LoginError.invalidEmail(email))
            return false
        }
        guard password.isValidPassword else {
            failValidation(withError: LoginError.invalidPassword)
            return false
        }
        return true
    }
    
    
}
