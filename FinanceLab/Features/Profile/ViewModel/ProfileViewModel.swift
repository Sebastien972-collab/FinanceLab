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
    
    /// Base locale de réponses
    var userAnswers: [Answer] = Answer.userAnswerDatabase
    
    /// Récupère les réponses d’un groupe thématique (ex : .professional)
    func answers(for category: AnswerCategory) -> [Answer] {
        userAnswers.filter { $0.answerCategory == category }
    }
}


