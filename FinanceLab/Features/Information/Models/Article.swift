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
    let image: String?
    let content: [ArticleContent]
    
    init(id: UUID = UUID(), title: String, image: String? = nil, content: [ArticleContent]) {
        self.id = id
        self.title = title
        self.image = image
        self.content = content
    }
}
