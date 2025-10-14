//
//  Glossaire.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

class Glossaire: Identifiable {
    var id = UUID()
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
