//
//  QuestionProfileExtension.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

extension Question {
    static var questionDatabase: [Question] {
        
        let questions: [Question] = [
            
            // MARK: - Situation personnelle et familiale
            Question(content: "Es-tu marié(e), pacsé(e) ou célibataire ?",
                     multipleChoice: true,
                     questionGroup: .personal),
            
            Question(content: "As-tu des enfants à charge ?",
                     multipleChoice: false,
                     questionGroup: .personal),
            
            Question(content: "As-tu d’autres personnes à charge (parents, proches, etc.) ?",
                     multipleChoice: false,
                     questionGroup: .personal),
            
            // MARK: - Situation professionnelle
            Question(content: "Quelle est ta situation professionnelle ?",
                     multipleChoice: true,
                     questionGroup: .professional),
            
            Question(content: "Quel est ton revenu mensuel net moyen ?",
                     multipleChoice: false,
                     questionGroup: .professional),
            
            Question(content: "As-tu des revenus complémentaires ?",
                     multipleChoice: false,
                     questionGroup: .professional),
            
            // MARK: - Situation financière
            Question(content: "As-tu des crédits en cours (immobilier, auto, consommation…) ?",
                     multipleChoice: false,
                     questionGroup: .financial),
            
            Question(content: "Quel est le montant total de tes charges mensuelles fixes ?",
                     multipleChoice: false,
                     questionGroup: .financial),
            
            Question(content: "Mets-tu de l’argent de côté chaque mois ?",
                     multipleChoice: false,
                     questionGroup: .financial),
            
            // MARK: - Patrimoine
            Question(content: "Es-tu propriétaire de ton logement principal ?",
                     multipleChoice: false,
                     questionGroup: .patrimony),
            
            Question(content: "Possèdes-tu d’autres biens immobiliers ?",
                     multipleChoice: false,
                     questionGroup: .patrimony),
            
            Question(content: "As-tu des placements financiers (PEL, assurance vie, bourse, crypto…) ?",
                     multipleChoice: false,
                     questionGroup: .patrimony),
            
            Question(content: "As-tu une épargne de précaution disponible ?",
                     multipleChoice: false,
                     questionGroup: .patrimony),
            
            // MARK: - Objectifs financiers
            Question(content: "As-tu un projet à court terme (1 à 3 ans) ?",
                     multipleChoice: false,
                     questionGroup: .objectives),
            
            Question(content: "As-tu un projet à moyen terme (3 à 7 ans) ?",
                     multipleChoice: false,
                     questionGroup: .objectives),
            
            Question(content: "As-tu un objectif à long terme (plus de 10 ans) ?",
                     multipleChoice: false,
                     questionGroup: .objectives),
            
            // MARK: - Gestion du risque & profil investisseur
            Question(content: "Comment réagis-tu face aux risques financiers ?",
                     multipleChoice: true,
                     questionGroup: .risk),
            
            Question(content: "Accepterais-tu de voir tes placements baisser temporairement pour espérer plus de gains ?",
                     multipleChoice: false,
                     questionGroup: .risk),
            
            Question(content: "Quel est ton horizon de placement ?",
                     multipleChoice: true,
                     questionGroup: .risk),
            
            // MARK: - Protection & prévoyance
            Question(content: "As-tu une assurance vie, invalidité ou décès ?",
                     multipleChoice: false,
                     questionGroup: .protection),
            
            Question(content: "As-tu une mutuelle ou complémentaire santé ?",
                     multipleChoice: false,
                     questionGroup: .protection),
            
            Question(content: "As-tu déjà prévu ta retraite (pension, PER, épargne retraite…) ?",
                     multipleChoice: false,
                     questionGroup: .protection)
        ]
        
        return questions
    }
}
