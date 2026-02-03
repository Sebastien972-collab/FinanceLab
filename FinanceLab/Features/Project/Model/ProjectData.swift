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
    var id: UUID
    let name: String
    let endDate: Date
    let iconName: String
    let creationDate: Date
    let amountTotal: Decimal
    let amountSaved: Decimal
    
    func toProject() -> Project {
        let project = Project(name: self.name, finalDate: self.endDate, amount: self.amountTotal, transactions: [], currency: .eur)
        project.id = self.id
        project.amountSaved = self.amountSaved
        project.iconName = self.iconName
        return project
    }
    
}
