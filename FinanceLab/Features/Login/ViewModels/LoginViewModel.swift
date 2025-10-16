//
//  LoginViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 16/10/2025.
//

import Foundation

@Observable
class LoginViewModel {
    func login(
        email: String,
        password: String
    ) {
        // Takes email, password, and logs to an existing account
    }
    
    func create(
        email: String,
        password: String,
        passwordConfirmation: String,
        firstName: String,
        lastName: String
    ) {
        // Takes email, password, first name and last name, and creates a new account with it
    }
}
