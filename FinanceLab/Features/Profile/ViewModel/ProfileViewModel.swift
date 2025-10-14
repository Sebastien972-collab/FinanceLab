//
//  ProfileViewModel.swift
//  FinanceLab
//
//  Created by Dembo on 09/10/2025.
//

import Foundation

@Observable
class ProfileViewModel {
    var currentUser: User = .init(firstName: "Sophie", lastName: "DAGUIN", email: "sohphie@gmail.com")
    var authService: AuthService = .init()
    
    
    func login() async  {
        do {
            try await authService.login(email: "sebastien.daguin@financelab.com", password: "Sebby972")
        } catch  {
            print(error.localizedDescription)
        }
        self.currentUser = authService.currentUser
    }
    
    
}
