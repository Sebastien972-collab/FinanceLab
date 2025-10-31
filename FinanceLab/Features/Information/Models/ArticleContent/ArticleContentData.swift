//
//  ArticleContentData.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 29/10/2025.
//

import Foundation

struct ArticleContentData: Identifiable, Codable, Hashable {
    let id: UUID?
    let orderPlacement: Int
    let type: String
    let content: String

    init(
        id: UUID? = UUID(),
        orderPlacement: Int,
        type: String,
        content: String
    ) {
        self.id = id
        self.orderPlacement = orderPlacement
        self.type = type
        self.content = content
    }
    
    func toArticleContent() -> ArticleContent {
             ArticleContent(
                id: id,
                orderPlacement: orderPlacement,
                type: ArticleContentType(rawValue: type) ?? ArticleContentType.paragraph,
                content: content
             )
        }
    

}

