//
//  AnswerChoice.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation
import Foundation

struct AnswerChoice: Identifiable, Hashable, Codable {
    let id: UUID
    var content: String
    var questionId: UUID    

    init(
        id: UUID = UUID(),
        content: String,
        questionId: UUID
    ) {
        self.id = id
        self.content = content
        self.questionId = questionId
    }
}
