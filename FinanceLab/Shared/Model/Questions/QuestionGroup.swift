//
//  QuestionGroup.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

import SwiftUI

enum QuestionGroup: String, CaseIterable, Codable, Identifiable {
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
        case .personal:
            return .userFill
        case .professional:
            return .bagSimpleFill
        case .patrimony:
            return .currencyDollardFill
        case .financial:
            return .houseLineFill
        case .objectives:
            return .targetFill
        case .risk:
            return .warningFill
        case .protection:
            return .shieldSlashFill
        }
    }
}


