//
//  Question.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

struct Question: Identifiable, Hashable{
    let id: UUID
    var label: String
    var content: String
    var followUpLabel: String?
    var questionGroup: QuestionGroup
    
    init(id: UUID = UUID(),label: String,content: String,followUpLabel: String? = nil,
        questionGroup: QuestionGroup
    ) {
        self.id = UUID()
        self.label = label
        self.content = content
        self.followUpLabel = followUpLabel
        self.questionGroup = questionGroup
    }
    
    func toQuestionData() -> QuestionsData{
        QuestionsData(
            id: id,
            label: label,
            content: content,
            followUpLabel: followUpLabel,
            questionGroup:  questionGroup.rawValue
        )
    }
}
