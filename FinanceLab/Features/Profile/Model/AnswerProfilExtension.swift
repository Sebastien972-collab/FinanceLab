//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.

import Foundation

extension Answer {
    static var answerChoiceDatabase: [AnswerChoice] {
        let questions = Question.questionDatabase
        var choices: [AnswerChoice] = []
        
        for question in questions {
            switch question.questionGroup {
                
            // Situation personnelle
            case .personal:
                if question.label == "Statut" {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Célibataire", questionId: question.id, answerCategory: .personal),
                        AnswerChoice(content: "Marié(e)", questionId: question.id, answerCategory: .personal),
                        AnswerChoice(content: "Pacsé(e)", questionId: question.id, answerCategory: .personal),
                        AnswerChoice(content: "Divorcé(e)", questionId: question.id, answerCategory: .personal),
                        AnswerChoice(content: "Veuf(ve)", questionId: question.id, answerCategory: .personal)
                    ])
                } else if ["Enfant", "Autres charges"].contains(question.label) {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .personal),
                        AnswerChoice(content: "Non", questionId: question.id, answerCategory: .personal)
                    ])
                }

            // Situation professionnelle
            case .professional:
                if question.label == "Emploi" {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "CDI", questionId: question.id, answerCategory: .professional),
                        AnswerChoice(content: "CDD", questionId: question.id, answerCategory: .professional),
                        AnswerChoice(content: "Indépendant", questionId: question.id, answerCategory: .professional),
                        AnswerChoice(content: "Étudiant", questionId: question.id, answerCategory: .professional),
                        AnswerChoice(content: "Sans emploi", questionId: question.id, answerCategory: .professional),
                        AnswerChoice(content: "Retraité", questionId: question.id, answerCategory: .professional)
                    ])
                } else if ["Revenus", "Revenus complémentaires"].contains(question.label) {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .professional),
                        AnswerChoice(content: "Non", questionId: question.id, answerCategory: .professional)
                    ])
                }

            // Situation financière
            case .financial:
                if ["Crédits", "Charges", "Épargne mensuelle"].contains(question.label) {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .financial),
                        AnswerChoice(content: "Non", questionId: question.id, answerCategory: .financial)
                    ])
                }

            // Patrimoine
            case .patrimony:
                if ["Logement", "Biens immobiliers", "Placements", "Épargne de précaution"].contains(question.label) {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .patrimony),
                        AnswerChoice(content: "Non", questionId: question.id, answerCategory: .patrimony)
                    ])
                }

            // Objectifs
            case .objectives:
                choices.append(contentsOf: [
                    AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .objectives),
                    AnswerChoice(content: "Non", questionId: question.id, answerCategory: .objectives)
                ])

            // Risque & profil investisseur
            case .risk:
                if question.label == "Risque" {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Prudent", questionId: question.id, answerCategory: .risk),
                        AnswerChoice(content: "Équilibré", questionId: question.id, answerCategory: .risk),
                        AnswerChoice(content: "Dynamique", questionId: question.id, answerCategory: .risk)
                    ])
                } else if question.label == "Tolérance" {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .risk),
                        AnswerChoice(content: "Non", questionId: question.id, answerCategory: .risk)
                    ])
                } else if question.label == "Horizon" {
                    choices.append(contentsOf: [
                        AnswerChoice(content: "< 2 ans", questionId: question.id, answerCategory: .risk),
                        AnswerChoice(content: "3-5 ans", questionId: question.id, answerCategory: .risk),
                        AnswerChoice(content: "5-10 ans", questionId: question.id, answerCategory: .risk),
                        AnswerChoice(content: "> 10 ans", questionId: question.id, answerCategory: .risk)
                    ])
                }

            // Protection & prévoyance
            case .protection:
                choices.append(contentsOf: [
                    AnswerChoice(content: "Oui", questionId: question.id, answerCategory: .protection),
                    AnswerChoice(content: "Non", questionId: question.id, answerCategory: .protection)
                ])
            }
        }
        
        return choices
    }
}
