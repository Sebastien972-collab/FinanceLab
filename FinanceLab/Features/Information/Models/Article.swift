//
//  Article.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

class Article: Identifiable {
    var id = UUID()
    let title: String
    let category: ArticleCategory
    let image: String?
    let content: [ArticleContent]
    
    init(id: UUID = UUID(), title: String, category: ArticleCategory, image: String, content: [ArticleContent]) {
        self.id = id
        self.title = title
        self.category = category
        self.image = image
        self.content = content
    }
}
