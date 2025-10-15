//
//  AnswerChoice.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//


import Foundation

// MARK: - Catégories de réponses
enum AnswerCategory: String, CaseIterable, Codable {
    case personal = "Situation personnelle et familiale"
    case professional = "Situation professionnelle"
    case financial = "Situation financière (revenus & charges)"
    case patrimony = "Patrimoine existant"
    case objectives = "Objectifs financiers"
    case risk = "Gestion du risque & profil investisseur"
    case protection = "Protection & prévoyance"
    
    var stringIcon: String {
        switch self {
        case .personal: "👤"
        case .professional: "💼"
        case .financial: "🏦"
        case .patrimony: "🏡"
        case .objectives: "🎯"
        case .risk: "⚖️"
        case .protection: "🛡️"
        }
    }
}
