//
//  Question.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

struct Question: Identifiable, Hashable/*, Codable*/ {
    let id: UUID
//    var icon: CategoryIcon
    var label: String
    var content: String
    var followUpLabel: String?
    var questionGroup: QuestionGroup
    
    init(/*icon: CategoryIcon ,*/label: String,content: String,followUpLabel: String? = nil,
        questionGroup: QuestionGroup
    ) {
        self.id = UUID()
//        self.icon = icon
        self.label = label
        self.content = content
        self.followUpLabel = followUpLabel
        self.questionGroup = questionGroup
    }
}
