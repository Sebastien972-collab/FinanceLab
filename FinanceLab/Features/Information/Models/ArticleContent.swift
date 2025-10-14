//
//  ArticleContent.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

enum ArticleContent {
    case paragraph(String)
    case subtitle(String)
    case image(url: String, caption: String?)
    case list(items: [String])
}
