//
//  UserAnswer.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

struct UserAnswer: Identifiable, Hashable, Codable {
    let id: UUID
    var content: String
    var userId: UUID
    var questionId: UUID    

    init(
        id: UUID = UUID(),
        content: String,
        userId: UUID,
        questionId: UUID
    ) {
        self.id = id
        self.content = content
        self.userId = userId
        self.questionId = questionId
    }
}

