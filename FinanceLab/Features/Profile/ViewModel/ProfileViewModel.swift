//
//  ProfileViewModel.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//  Refactored by Gemini (Architecture Expert) 2026
//

import Foundation
import FinanceCore

@MainActor
@Observable
class ProfileViewModel {
    
    // Dependencies
    private let manager: CustomerManager = .shared
    private let answerService: AnswersService = .shared
    
    // Data State
    var userAnswers: [Answer] = []
    
    // Computed (Raccourcis pour la vue)
    var currentUser: Customer {
        manager.currentUser
    }
    
    var fullName: String {
        "\(currentUser.firstName) \(currentUser.lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    var initials: String {
        let first = currentUser.firstName.first?.uppercased() ?? ""
        let last = currentUser.lastName.first?.uppercased() ?? ""
        return "\(first)\(last)"
    }
    
    // UI State
    var isLoading: Bool = false
    var showError: Bool = false
    var error: Error = LoginError.unknown
    
    // MARK: - Actions
    
    func fetchUserData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 1. Rafraîchir le profil utilisateur
            try await manager.fetchProfile()
            
            // 2. Récupérer l'historique des réponses
            // (Supposons que cette méthode existe dans votre service, sinon on filtre localement)
            // userAnswers = try await answerService.fetchAnswers(for: currentUser.id)
            userAnswers = currentUser.answers // Fallback sur les données locales du user
            
        } catch {
            // Silencieux sur le profil, on garde les données en cache si erreur réseau
            print("Erreur refresh profil: \(error)")
        }
    }
    
    func logout(onSucess: (() -> Void)? = nil) {
        manager.logout()
        onSucess?()
    }
}
