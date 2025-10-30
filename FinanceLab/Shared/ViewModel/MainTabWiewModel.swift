//
//  MainTabWiewModel.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 17/10/2025.
//

import SwiftUI

@Observable
class TabViewModel {
    enum Selection {
        case home, project, inform
    }
    var selection: Selection = .home
    var manager: UserManager = .shared
    var currentUser: User { manager.currentUser }
    var authState: AuthState = .loading
    var error: Error? = nil
    var showError: Bool = false

    init() {
        Task { await checkSession() }
    }

    func checkSession() async {
        // Vérifie si un token est valide et essaie de fetch le profil
        do {
            try await manager.fetchProfile()
            authState = .authenticated
        } catch {
            print(error.localizedDescription)
            authState = .notAuthenticated
        }
    }

    func logout() {
        manager.logout()
        authState = .notAuthenticated
    }

    func login(email: String, password: String) async {
        do {
            try await manager.login(email: email, password: password)
            try await manager.fetchProfile()
            authState = .authenticated
        } catch {
            self.error = error
            self.showError = true
            authState = .notAuthenticated
        }
    }
    
    func setupQuestionDatabase() async {
        do {
            let question = try await QuestionsService.shared.fetchQuestion()
            if question.isEmpty {
                
            }
        } catch <#pattern#> {
            <#statements#>
        }
    }
}

enum AuthState {
    case authenticated
    case notAuthenticated
    case loading
}
