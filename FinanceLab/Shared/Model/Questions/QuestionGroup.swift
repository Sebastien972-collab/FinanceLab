//
//  QuestionGroup.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

enum QuestionGroup: String, CaseIterable, Codable {
    case personal = "Situation personnelle et familiale"
    case professional = "Situation professionnelle"
    case patrimony = "Patrimoine existant"
    case financial = "Situation financière"
    case objectives = "Objectifs financiers"
    case risk =  "Gestion du risque & profil investisseur"
    case protection =  "Protection & prévoyance"
    
    
    
    var stringIcon: String {
        switch self {
        case .personal:
            "👤"
        case .professional:
            "💼"
        case .patrimony:
            "🏦"
        case .financial:
            "🏡"
        case .objectives:
            "🎯"
        case .risk:
            "⚖️"
        case .protection:
            "🛡️"
        }
    }
}


