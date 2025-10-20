//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 13/10/2025.
//

import Foundation

struct Answer: Identifiable, Hashable {
    let id: UUID
    var content: String
    var userId: UUID
    let question: Question
    
    init(
        id: UUID = UUID(),
        content: String,
        userId: UUID,
        question: Question,
    ) {
        self.id = id
        self.content = content
        self.userId = userId
        self.question = question
    }
}
