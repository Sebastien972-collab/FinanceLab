//
//  ArticleData.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 28/10/2025.
//

import Foundation

struct ArticleData: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let image: String
    let creationDate: Date?
    let articleCategory: String

    init(
        id: UUID,
        title: String,
        image: String,
        creationDate: Date? = nil,
        articleCategory: String
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.creationDate = creationDate
        self.articleCategory = articleCategory
    }
    
    func toArticle() -> Article {
             Article(
                id: id,
                title: title,
                image: image,
                creationDate: creationDate,
                articleCategory: ArticleCategory(rawValue: articleCategory) ?? ArticleCategory.article
            )
        }
}


