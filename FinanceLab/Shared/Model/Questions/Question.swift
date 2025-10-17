//
//  Question.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

struct Question: Identifiable, Hashable, Codable {
    let id: UUID
    var content: String
    var multipleChoice: Bool
    var questionGroup: QuestionGroup = .patrimony
    
    init(id: UUID = UUID(), content: String, multipleChoice: Bool = false,
         questionGroup: QuestionGroup ) {
        self.id = id
        self.content = content
        self.multipleChoice = multipleChoice
        self.questionGroup = questionGroup
    }
}
