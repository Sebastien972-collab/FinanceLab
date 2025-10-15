//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 13/10/2025.
//

import Foundation
struct Answer: Identifiable, Hashable, Codable {
    let id: UUID
    var content: String
    var userId: UUID
    var questionId: UUID
    var answerCategory: AnswerCategory
    
    init(
        id: UUID = UUID(),
        content: String,
        userId: UUID,
        questionId: UUID,
        answerCategory: AnswerCategory
    ) {
        self.id = id
        self.content = content
        self.userId = userId
        self.questionId = questionId
        self.answerCategory = answerCategory
    }
}
