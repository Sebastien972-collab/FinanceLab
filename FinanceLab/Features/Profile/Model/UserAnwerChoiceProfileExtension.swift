//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

extension AnswerChoice {
    static var answerChoiceDatabase: [AnswerChoice] {
        
     
        let questionProId = UUID()
        let questionSalaireId = UUID()
        let questionMaisonId = UUID()
        
        return [
            
            AnswerChoice(content: "CDI", questionId: questionProId),
            AnswerChoice(content: "CDD", questionId: questionProId),
            AnswerChoice(content: "Indépendant", questionId: questionProId),
            AnswerChoice(content: "Sans emploi", questionId: questionProId),
            
          
            AnswerChoice(content: "Moins de 1000 €", questionId: questionSalaireId),
            AnswerChoice(content: "1000 à 2500 €", questionId: questionSalaireId),
            AnswerChoice(content: "2500 à 5000 €", questionId: questionSalaireId),
            AnswerChoice(content: "Plus de 5000 €", questionId: questionSalaireId),
            
            
            AnswerChoice(content: "Oui", questionId: questionMaisonId),
            AnswerChoice(content: "Non", questionId: questionMaisonId)
        ]
    }
}

