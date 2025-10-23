//
//  UserAnswer.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//



import Foundation

struct AnswerChoice: Identifiable {
    let id: UUID
    var content: String
    var questionId: UUID
    
    init(
        id: UUID = UUID(),
        content: String,
        questionId: UUID,
    ) {
        self.id = id
        self.content = content
        self.questionId = questionId
    }
}
