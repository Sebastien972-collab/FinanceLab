//
//  QuestionGroup.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.



import Foundation

enum QuestionGroup: String, CaseIterable, Codable, Identifiable {
    case essential = "essential"
    case personal = "personal"
    case savings = "savings"
    case protection = "protection"
    case patrimony = "patrimony"
    case risk = "risk"
    
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .essential: return "Questions essentielles"
        case .personal: return "Situation personnelle et familiale"
        case .savings: return "Épargne de précaution"
        case .protection: return "Protection & prévoyance"
        case .patrimony: return "Patrimoine existant"
        case .risk: return "Gestion du risque & profil investisseur"
        }
    }
    
    var icon: CategoryIcon {
        switch self {
        case .essential:    return .selectionFill
        case .personal:     return .userFill
        case .savings:      return .handCoinsFill
        case .protection:   return .shieldSlashFill
        case .patrimony:    return .currencyEurFill
        case .risk:         return .lifebuoyFill
        }
    }

    var titlePrefix: String {
        switch self {
        case .essential:    return "Essentiel"
        case .personal:     return "Enfant"
        case .savings:      return "Épargne"
        case .protection:   return "Protection"
        case .patrimony:    return "Patrimoine"
        case .risk:         return "Risque"
        }
    }
}
