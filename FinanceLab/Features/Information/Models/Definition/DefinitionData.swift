//
//  Glossaire.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

struct DefinitionData: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let content: String
    
    func toDefinition() -> Definition {
        Definition(
            name: name,
            content: content
        )
    }
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}
