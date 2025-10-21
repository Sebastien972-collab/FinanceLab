//
//  ProjectData.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 20/10/2025.
//

import Foundation
import FinanceCore
/// Modèle représentant un projet côté client (correspond à ton API Vapor)
struct ProjectData: Codable, Identifiable, Sendable {
    let id: UUID
    let userID: UUID
    let name: String
    let goalAmount: Double
    let amountSaved: Double
    let finalDate: Date
    let currentImage: String
    
    // Clés explicites pour correspondre à l’API
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        case name
        case goalAmount
        case amountSaved
        case finalDate
        case currentImage
    }
    
    func toProject() -> Project {
        let project = Project(name: name, currentImage: currentImage, finalDate: finalDate, amount: Decimal(goalAmount))
        return project
    }
    
}
