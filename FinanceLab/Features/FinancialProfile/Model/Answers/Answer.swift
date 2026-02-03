//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 13/10/2025.
//

import Foundation

struct Answer: Identifiable, Equatable {
    let id = UUID()
    var content: String
    var user: Customer
    let question: Question
    
    init(
        content: String,
        user: Customer,
        question: Question,
    ) {
        self.content = content
        self.user = user
        self.question = question
    }
    
    
    func toAnswerData() -> AnswersData{
        AnswersData(
            id: id,
            content: content, idQuestion: question.id
        )
    }
}
