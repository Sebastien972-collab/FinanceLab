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
            try await manager.fetchProfile()
            userAnswers = currentUser.answers
            
        } catch {
            // Silencieux sur le profil, on garde les données en cache si erreur réseau
            print("Erreur refresh profil: \(error)")
        }
    }
    
    func updateAnswer(_ answer: Answer, with content: String) async {
        do {
            let updatedAnswer = Answer(
                id: answer.id,
                content: content.replacingOccurrences(of: ",", with: "."),
                user: currentUser,
                question: answer.question
            )
            let updatedAnswers = try await answerService.upsertAnswer(updatedAnswer)
            manager.currentUser.answers = updatedAnswers
            userAnswers = updatedAnswers
        } catch {
            self.error = error
            self.showError = true
        }
    }

}
