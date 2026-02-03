//
//  QuestionsService.swift
//  FinanceLab
//
//  Created by Dembo on 29/10/2025.
//

import Foundation

final class QuestionsService{
    static let shared = QuestionsService()
    private let keychain = KeychainService.shared
    private let service = NetworkingService.shared
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
        let questionRequest = APIRequest(endpoint: "/questions/\(idQuestion)", httpMethod: .GET)
        let response = try await service.request(questionRequest, responseType: QuestionsData.self)
        return response.toQuestion()
    }
}
