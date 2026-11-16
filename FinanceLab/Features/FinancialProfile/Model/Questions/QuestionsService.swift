//
//  QuestionsService.swift
//  FinanceLab
//
//  Created by Dembo on 29/10/2025.
//

import Foundation

final class QuestionsService {
    static let shared = QuestionsService()
    private var questions: [Question] = []
    
    func getQuestionByGroup(_ questionGroup: QuestionGroup ) async throws -> [Question] {
        guard questions.isEmpty else {
            return questions.filter { $0.questionGroup == questionGroup }
        }
        _ = try await fetchQuestion()
        return questions.filter { $0.questionGroup == questionGroup }
    }
    
    func fetchQuestion() async throws -> [Question] {
        questions = Question.questionDatabase
        return questions
    }
    
    func getQuestion(byID idQuestion: UUID) async throws -> Question {
        if questions.isEmpty {
            _ = try await fetchQuestion()
        }

        guard let question = questions.first(where: { $0.id == idQuestion }) else {
            throw LoginError.custom("Question introuvable.")
        }

        return question
    }
}
