//
//  AnswerChoice.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//


//import Foundation
//
//// MARK: - Catégories de réponses
//enum AnswerCategory: String, CaseIterable, Codable {
//    case personal = "Situation personnelle et familiale"
//    case professional = "Situation professionnelle"
//    case financial = "Situation financière (revenus & charges)"
//    case patrimony = "Patrimoine existant"
//    case objectives = "Objectifs financiers"
//    case risk = "Gestion du risque & profil investisseur"
//    case protection = "Protection & prévoyance"
//    
//    var stringIcon: String {
//        switch self {
//        case .personal: "👤"
//        case .professional: "💼"
//        case .financial: "🏦"
//        case .patrimony: "🏡"
//        case .objectives: "🎯"
//        case .risk: "⚖️"
//        case .protection: "🛡️"
//        }
//    }
//}

import Foundation
import SwiftUI

enum AnswerCategory: String, CaseIterable, Codable, Identifiable {
    case personal = "Situation personnelle et familiale"
    case professional = "Situation professionnelle"
    case patrimony = "Patrimoine existant"
    case financial = "Situation financière"
    case objectives = "Objectifs financiers"
    case risk = "Gestion du risque & profil investisseur"
    case protection = "Protection & prévoyance"
    
    var id: String { rawValue }

    var icon: CategoryIconsProfil {
        switch self {
        case .personal:     return .userFill
        case .professional: return .bagSimpleFill
        case .patrimony:    return .currencyDollardFill
        case .financial:    return .houseLineFill
        case .objectives:   return .targetFill
        case .risk:         return .warningFill
        case .protection:   return .shieldSlashFill
        }
    }

    var titlePrefix: String {
        switch self {
        case .personal:     return "Enfant"
        case .professional: return "Travail"
        case .patrimony:    return "Patrimoine"
        case .financial:    return "Finance"
        case .objectives:   return "Objectif"
        case .risk:         return "Risque"
        case .protection:   return "Protection"
        }
    }
}
