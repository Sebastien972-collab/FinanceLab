//
//  ArticleContentService.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 29/10/2025.
//

import Foundation

class ArticleContentService {
    var keychain = KeychainService.shared
    var service = NetworkingService.shared
    
    func fetchArticleContents(idArticle: UUID) async throws -> [ArticleContent] {
        let token = try keychain.getToken()
        let articleContentRequest = APIRequest(endpoint: "/articleContents/\(idArticle)", httpMethod: .GET)
        let response = try await service.request(articleContentRequest, responseType: [ArticleContentData].self, token: token)
        return response.map{ $0.toArticleContent() }
    }
}
