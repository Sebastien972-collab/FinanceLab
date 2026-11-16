//
//  QuestionnaireDraftStore.swift
//  FinanceLab
//
//  Created by Codex on 20/03/2026.
//

import Foundation

@MainActor
@Observable
final class QuestionnaireDraftStore {
    static let shared = QuestionnaireDraftStore()

    private(set) var answersByQuestionID: [UUID: String] = [:]

    private init() {}

    var hasDraft: Bool {
        !answersByQuestionID.isEmpty
    }

    func upsert(question: Question, content: String) {
        answersByQuestionID[question.id] = content
    }

    func answer(for question: Question) -> String {
        answersByQuestionID[question.id] ?? ""
    }

    func hasAnswer(for question: Question) -> Bool {
        answersByQuestionID[question.id] != nil
    }

    func buildAnswers(for user: Customer) -> [Answer] {
        Question.questionDatabase.compactMap { question in
            guard let content = answersByQuestionID[question.id] else { return nil }
            return Answer(id: question.id, content: content, user: user, question: question)
        }
    }

    func clear() {
        answersByQuestionID.removeAll()
    }
}
