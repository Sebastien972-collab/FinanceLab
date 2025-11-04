//
//  AnswersService.swift
//  FinanceLab
//
//  Created by Dembo on 30/10/2025.
//

import Foundation

final class AnswersService{
    static let shared = AnswersService()
    private init() {}
    let keychain = KeychainService.shared
    let service = NetworkingService.shared
    let userManager = UserManager.shared
    func fetchAnswer() async throws -> [AnswersData] {
        let token = try keychain.getToken()
        let answersRequest = APIRequest(endpoint: "/answers", httpMethod: .GET)
        let response = try await service.request(answersRequest, responseType: [AnswersData].self, token: token)
        return response
    }
    
    func postAnswer(answer: AnswersData) async throws -> AnswersData {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(answer)
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/answers/", httpMethod: .POST, body: data)
        let answer = try await service.request(apiRequest, responseType: AnswersData.self, token: token)
        return answer
    }
    func postAllAnswers(answers: [AnswersData]) async throws -> [AnswersData] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(answers)
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/answers/bulk", httpMethod: .POST, body: data)
        let answer = try await service.request(apiRequest, responseType: [AnswersData].self, token: token)
        return answer
    }
    func fetchAllUserAnswers() async throws -> [AnswersData] {
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/answers/", httpMethod: .GET)
        let answer = try await service.request(apiRequest, responseType: [AnswersData].self, token: token)
        return answer
    }
    
    func putAnswer(answer: AnswersData) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(answer)
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/answers/\(answer.id)", httpMethod: .PUT, body: data)
        let _ = try await service.request(apiRequest, responseType: AnswersData.self, token: token)
    }
    
    func deleteAnswer(id: UUID) async throws {
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/answers/\(id)", httpMethod: .DELETE)
        let _ = try await service.request(apiRequest, responseType: EmptyResponse.self, token: token)
    }
}
