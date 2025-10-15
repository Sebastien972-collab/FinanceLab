//
//  UserAnswer.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//



import Foundation



struct AnswerChoice: Identifiable, Hashable, Codable {
    let id: UUID
    var content: String
    var questionId: UUID
    var answerCategory: AnswerCategory
    
    init(
        id: UUID = UUID(),
        content: String,
        questionId: UUID,
        answerCategory: AnswerCategory
    ) {
        self.id = id
        self.content = content
        self.questionId = questionId
        self.answerCategory = answerCategory
    }
}
