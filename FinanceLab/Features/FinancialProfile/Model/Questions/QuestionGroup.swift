//
//  QuestionGroup.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.



import Foundation

enum QuestionGroup: String, CaseIterable, Codable, Identifiable {
    case essential = "Questions essentielles"
    case personal = "Situation personnelle et familiale"
    case savings = "Épargne de précaution"
    case protection = "Protection & prévoyance"
    case patrimony = "Patrimoine existant"
    case risk = "Gestion du risque & profil investisseur"
    
    var id: String { rawValue }

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
