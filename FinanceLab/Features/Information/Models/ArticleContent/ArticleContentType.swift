//
//  ArticleContent.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

enum ArticleContentType: String {
    case paragraph, subtitle, image, list
    
    var id: String { rawValue }
}
