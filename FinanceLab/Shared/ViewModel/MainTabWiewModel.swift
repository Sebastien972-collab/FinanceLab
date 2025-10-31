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
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        if !hasSeenOnboarding {
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            self.authState = .firstLaunch
        } else {
            self.authState = .loading
            Task { await checkSession() }
        }
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
            launchError(error)
            authState = .notAuthenticated
        }
    }
    
    func launchError(_ error: Error)  {
        self.error = error
        self.showError = true
    }
}

enum AuthState {
    case firstLaunch
    case questionPhase
    case authenticated
    case notAuthenticated
    case loading
}
