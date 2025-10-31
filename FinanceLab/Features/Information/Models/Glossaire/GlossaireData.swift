//
//  Glossaire.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

struct GlossaireData: Identifiable, Codable, Hashable {
    var id = UUID()
    let title: String
    let description: String
    
    func toGlossaire() -> Glossaire {
        Glossaire(
            title: title,
            description: description
        )
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
