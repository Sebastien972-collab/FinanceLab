//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 13/10/2025.
//

import Foundation

struct Answer: Identifiable {
    let id = UUID()
    var content: String
    var user: User
    let question: Question
    
    init(
        content: String,
        user: User,
        question: Question,
    ) {
        self.content = content
        self.user = user
        self.question = question
    }
}
