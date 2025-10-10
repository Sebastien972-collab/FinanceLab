//
//  QuestionGroup.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

struct QuestionGroup: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var icon: String
    
    init(id: UUID = UUID(), title: String, icon: String) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}
