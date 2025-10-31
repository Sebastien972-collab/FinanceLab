//
//  ArticleService.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 28/10/2025.
//

import Foundation

class ArticleService {
    var keychain = KeychainService.shared
    var service = NetworkingService.shared
    
    func fetchArticle(by id: UUID) async throws -> Article {
        let token = try keychain.getToken()
        let articleRequest = APIRequest(endpoint: "/articles/\(id)", httpMethod: .GET)
        let response = try await service.request(articleRequest, responseType: ArticleData.self,token: token)
        return response.toArticle()
    }
    
    func fetchArticles() async throws -> [Article] {
        let token = try keychain.getToken()
        let articleRequest = APIRequest(endpoint: "/articles/", httpMethod: .GET)
        let response = try await service.request(articleRequest, responseType: [ArticleData].self, token: token)
        return response.map{ $0.toArticle() }
    }
}
