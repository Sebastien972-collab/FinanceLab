//
//  AnswersData.swift
//  FinanceLab
//
//  Created by Dembo on 30/10/2025.
//

import Foundation

struct AnswersData: Identifiable, Equatable, Codable {
    let id: UUID?
    let content: String
    let idQuestion: UUID
    
    func toAnswer(user: User, question: Question) -> Answer{
        Answer(content: self.content, user: user, question: question)
    }
}
