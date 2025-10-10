//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

extension UserAnswer {
    static var userAnswerDatabase: [UserAnswer] {
        
        
        let user1Id = UUID()
        let user2Id = UUID()
        
        let questionProId = UUID()
        let questionSalaireId = UUID()
        let questionMaisonId = UUID()
        
        return [
            UserAnswer(content: "Je suis en CDI", userId: user1Id, questionId: questionProId),
            UserAnswer(content: "Je gagne 1300 € / mois", userId: user1Id, questionId: questionSalaireId),
            UserAnswer(content: "Oui, je suis propriétaire", userId: user1Id, questionId: questionMaisonId),
            
            UserAnswer(content: "Auto-entrepreneur", userId: user2Id, questionId: questionProId),
            UserAnswer(content: "Revenus variables selon les mois", userId: user2Id, questionId: questionSalaireId)
        ]
    }
}

