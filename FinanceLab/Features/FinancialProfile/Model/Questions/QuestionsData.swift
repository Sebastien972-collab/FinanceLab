//
//  QuestionsData.swift
//  FinanceLab
//
//  Created by Dembo on 29/10/2025.
//

import Foundation

struct QuestionsData: Identifiable, Equatable, Codable {
    let id: UUID?
    let label: String
    let content: String
    let followUpLabel: String?
    let questionGroup: String
    
    func toQuestion() -> Question {
        Question(
            id: id ?? .init(),
            label: label,
            content: content,
            followUpLabel: followUpLabel,
            questionGroup:  QuestionGroup(rawValue: questionGroup) ?? .essential
        )
    }
    
}


