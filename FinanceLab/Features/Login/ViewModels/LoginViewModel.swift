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
        // Takes email, password, and logs to an existing account
        isWorking = true
        checkField()
        do {
            try await manager.login(email: email, password: password)
            if let callback = callback {
                DispatchQueue.main.async {
                    callback()
                }
            }
        } catch  {
            isWorking = false
            self.error = error
            self.showError = true
        }
    }
    
    func create(callback: (() -> Void)? = nil) async {
        // Takes email, password, first name and last name, and creates a new account with it
        isWorking = true
        checkField()
        do {
            try await manager.create(email: email, password: password)
            if let callback = callback {
                DispatchQueue.main.async {
                    callback()
                }
            }
        } catch  {
            self.error = error
            self.showError = true
        }
    }
    
    func fetchUser() async {
        do {
            try await manager.fetchProfile()
        } catch  {
            self.error = error
            self.showError = true
        }
    }
    ///A function that verifies that the camps are not empty
    private func checkField() {
        if pickerSelected == 0 {
            guard !email.isEmpty && !password.isEmpty else {
                isWorking = false
                self.error = LoginError.emptyFiels
                self.showError = true
                return
            }
        } else  {
            guard !email.isEmpty || !password.isEmpty || !passwordConfirmation.isEmpty || !firstName.isEmpty || !lastName.isEmpty else {
                isWorking = false
                self.error = LoginError.emptyFiels
                self.showError = true
                return
            }
        }
    }
}
