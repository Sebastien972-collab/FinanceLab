//
//  QuestionGroupProfilExtention.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation
extension QuestionGroup {
    static var allGroups: [QuestionGroup] {
        [
            QuestionGroup(title: "Situation personnelle et familiale", icon: "👤"),
            QuestionGroup(title: "Situation professionnelle", icon: "💼"),
            QuestionGroup(title: "Situation financière", icon: "🏦"),
            QuestionGroup(title: "Patrimoine existant", icon: "🏡"),
            QuestionGroup(title: "Objectifs financiers", icon: "🎯"),
            QuestionGroup(title: "Gestion du risque & profil investisseur", icon: "⚖️"),
            QuestionGroup(title: "Protection & prévoyance", icon: "🛡️")
        ]
    }
}
