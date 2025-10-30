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
        
        func fetchQuestion() async throws -> [Question] {
            let token = try keychain.getToken()
            let questionsRequest = APIRequest(endpoint: "/questions/", httpMethod: .GET)
            let response = try await service.request(questionsRequest, responseType: [QuestionsData].self, token: token)
            return response.map{ $0.toQuestion() }
        }
        func postQuestion(question: QuestionsData) async throws {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(question)
            let token = try keychain.getToken()
            let apiRequest = APIRequest(endpoint: "/questions/", httpMethod: .POST, body: data)
            let _ = try await service.request(apiRequest, responseType: QuestionsData.self, token: token)
        }
//
//        func putQuestion(question: QuestionsData) async throws {
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .iso8601
//            let data = try encoder.encode(question)
//            let token = try keychain.getToken()
//            let apiRequest = APIRequest(endpoint: "/question/\(question.id)", httpMethod: .PUT, body: data)
//            let _ = try await service.request(apiRequest, responseType: QuestionsData.self, token: token)
//        }
//
//        func deleteQuestion(id: UUID) async throws {
//            let token = try keychain.getToken()
//            let apiRequest = APIRequest(endpoint: "/question/\(id)", httpMethod: .DELETE)
//            let _ = try await service.request(apiRequest, responseType: EmptyResponse.self, token: token)
//        }
}
