//
//  Glossaire.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

class Definition: Identifiable {
    var id = UUID()
    let name: String
    let content: String
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}
