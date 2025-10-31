//
//  ArticleContent.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 31/10/2025.
//

import Foundation

@Observable
class ArticleContent: Identifiable {
    let id: UUID?
    let orderPlacement: Int
    let type: ArticleContentType
    let content: String

    init(
        id: UUID? = UUID(),
        orderPlacement: Int,
        type: ArticleContentType,
        content: String,
    ) {
        self.id = id
        self.orderPlacement = orderPlacement
        self.type = type
        self.content = content
    }
}
