//
//  Question.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

enum QuestionInputKind: String, Codable, Hashable {
    case currency
    case count
    case percentage
    case years

    var suffix: String? {
        switch self {
        case .currency:
            return "€"
        case .count:
            return nil
        case .percentage:
            return "%"
        case .years:
            return "ans"
        }
    }
}

enum QuestionFinancialRole: String, Codable, Hashable {
    case income
    case expense
    case neutral
}

struct Question: Identifiable, Hashable {
    let id: UUID
    var label: String
    var content: String
    var followUpLabel: String?
    var questionGroup: QuestionGroup
    var inputKind: QuestionInputKind
    var financialRole: QuestionFinancialRole
    
    init(
        id: UUID,
        label: String,
        content: String,
        followUpLabel: String? = nil,
        questionGroup: QuestionGroup,
        inputKind: QuestionInputKind = .currency,
        financialRole: QuestionFinancialRole = .neutral
    ) {
        self.id = id
        self.label = label
        self.content = content
        self.followUpLabel = followUpLabel
        self.questionGroup = questionGroup
        self.inputKind = inputKind
        self.financialRole = financialRole
    }
    
    func toQuestionData() -> QuestionsData {
        QuestionsData(
            id: id,
            label: label,
            content: content,
            followUpLabel: followUpLabel,
            questionGroup:  questionGroup.rawValue
        )
    }
}
