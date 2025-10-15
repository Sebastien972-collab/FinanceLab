//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.

import Foundation
//
// MARK: - Base de données simulée des réponses et des choix
extension Answer {
    static var answerChoiceDatabase: [AnswerChoice] {
        let questions = Question.questionDatabase
        var choices: [AnswerChoice] = []

        // 🧍‍♂️ 1. Statut matrimonial
        if let maritalStatusQuestion = questions.first(where: { $0.content.contains("marié") }) {
            choices.append(contentsOf: [
                AnswerChoice(content: "Célibataire", questionId: maritalStatusQuestion.id, answerCategory: .personal),
                AnswerChoice(content: "Marié(e)", questionId: maritalStatusQuestion.id, answerCategory: .personal),
                AnswerChoice(content: "Pacsé(e)", questionId: maritalStatusQuestion.id, answerCategory: .personal)
            ])
        }

        // 💼 2. Situation professionnelle
        if let employmentStatusQuestion = questions.first(where: { $0.content.contains("situation professionnelle") }) {
            choices.append(contentsOf: [
                AnswerChoice(content: "CDI", questionId: employmentStatusQuestion.id, answerCategory: .professional),
                AnswerChoice(content: "CDD", questionId: employmentStatusQuestion.id, answerCategory: .professional),
                AnswerChoice(content: "Indépendant", questionId: employmentStatusQuestion.id, answerCategory: .professional),
                AnswerChoice(content: "Étudiant", questionId: employmentStatusQuestion.id, answerCategory: .professional),
                AnswerChoice(content: "Retraité", questionId: employmentStatusQuestion.id, answerCategory: .professional)
            ])
        }

        // ⚖️ 6. Profil de risque
        if let riskProfileQuestion = questions.first(where: { $0.content.contains("risques financiers") }) {
            choices.append(contentsOf: [
                AnswerChoice(content: "Prudent", questionId: riskProfileQuestion.id, answerCategory: .risk),
                AnswerChoice(content: "Équilibré", questionId: riskProfileQuestion.id, answerCategory: .risk),
                AnswerChoice(content: "Dynamique", questionId: riskProfileQuestion.id, answerCategory: .risk)
            ])
        }

        // ⏳ Horizon de placement
        if let investmentHorizonQuestion = questions.first(where: { $0.content.contains("horizon de placement") }) {
            choices.append(contentsOf: [
                AnswerChoice(content: "< 2 ans", questionId: investmentHorizonQuestion.id, answerCategory: .risk),
                AnswerChoice(content: "3-5 ans", questionId: investmentHorizonQuestion.id, answerCategory: .risk),
                AnswerChoice(content: "> 10 ans", questionId: investmentHorizonQuestion.id, answerCategory: .risk)
            ])
        }

        return choices
    }

    static var userAnswerDatabase: [Answer] {
        let userId = UUID()
        let questions = Question.questionDatabase

        return [
            // 1️⃣ Situation personnelle
            Answer(content: "Marié(e)", userId: userId, questionId: questions[0].id, answerCategory: .personal),
            Answer(content: "Oui, deux enfants", userId: userId, questionId: questions[1].id, answerCategory: .personal),
            Answer(content: "Non", userId: userId, questionId: questions[2].id, answerCategory: .personal),

            // 2️⃣ Situation professionnelle
            Answer(content: "CDI", userId: userId, questionId: questions[3].id, answerCategory: .professional),
            Answer(content: "3 200 €", userId: userId, questionId: questions[4].id, answerCategory: .professional),
            Answer(content: "Oui, revenus locatifs", userId: userId, questionId: questions[5].id, answerCategory: .professional),

            // 3️⃣ Situation financière
            Answer(content: "Oui, prêt immobilier", userId: userId, questionId: questions[6].id, answerCategory: .financial),
            Answer(content: "1 200 €", userId: userId, questionId: questions[7].id, answerCategory: .financial),
            Answer(content: "Oui, 300 € par mois", userId: userId, questionId: questions[8].id, answerCategory: .financial),

            // 4️⃣ Patrimoine existant
            Answer(content: "Oui", userId: userId, questionId: questions[9].id, answerCategory: .patrimony),
            Answer(content: "Non", userId: userId, questionId: questions[10].id, answerCategory: .patrimony),
            Answer(content: "Oui, assurance vie", userId: userId, questionId: questions[11].id, answerCategory: .patrimony),
            Answer(content: "Oui, 10 000 € disponibles", userId: userId, questionId: questions[12].id, answerCategory: .patrimony),

            // 5️⃣ Objectifs financiers
            Answer(content: "Acheter une maison", userId: userId, questionId: questions[13].id, answerCategory: .objectives),
            Answer(content: "Changer de voiture", userId: userId, questionId: questions[14].id, answerCategory: .objectives),
            Answer(content: "Préparer ma retraite", userId: userId, questionId: questions[15].id, answerCategory: .objectives),

            // 6️⃣ Gestion du risque
            Answer(content: "Équilibré", userId: userId, questionId: questions[16].id, answerCategory: .risk),
            Answer(content: "Oui", userId: userId, questionId: questions[17].id, answerCategory: .risk),
            Answer(content: "3-5 ans", userId: userId, questionId: questions[18].id, answerCategory: .risk),

            // 7️⃣ Protection & prévoyance
            Answer(content: "Oui", userId: userId, questionId: questions[19].id, answerCategory: .protection),
            Answer(content: "Oui", userId: userId, questionId: questions[20].id, answerCategory: .protection),
            Answer(content: "Oui", userId: userId, questionId: questions[21].id, answerCategory: .protection)
        ]
    }
}
