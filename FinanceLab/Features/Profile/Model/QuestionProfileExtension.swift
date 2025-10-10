//
//  QuestionProfileExtension.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//


import Foundation

extension Question {
    static var questionDatabase: [Question] {
        
       
        let personalGroup = QuestionGroup(title: "Situation personnelle et familiale", icon: "👤")
        let professionalGroup = QuestionGroup(title: "Situation professionnelle", icon: "💼")
        let financialGroup = QuestionGroup(title: "Situation financière", icon: "🏦")
        let patrimonyGroup = QuestionGroup(title: "Patrimoine existant", icon: "🏡")
        let objectivesGroup = QuestionGroup(title: "Objectifs financiers", icon: "🎯")
        let riskGroup = QuestionGroup(title: "Gestion du risque & profil investisseur", icon: "⚖️")
        let protectionGroup = QuestionGroup(title: "Protection & prévoyance", icon: "🛡️")
        
      
        let questions: [Question] = [
           
            Question(content: "Es-tu marié(e), pacsé(e) ou célibataire ?",
                     multipleChoice: true,
                     questionGroupId: personalGroup.id),
            
            Question(content: "As-tu des enfants à charge ?",
                     multipleChoice: false,
                     questionGroupId: personalGroup.id),
            
            Question(content: "As-tu d’autres personnes à charge (parents, proches, etc.) ?",
                     multipleChoice: false,
                     questionGroupId: personalGroup.id),
            
           
            Question(content: "Quelle est ta situation professionnelle ?",
                     multipleChoice: true,
                     questionGroupId: professionalGroup.id),
            
            Question(content: "Quel est ton revenu mensuel net moyen ?",
                     multipleChoice: false,
                     questionGroupId: professionalGroup.id),
            
            Question(content: "As-tu des revenus complémentaires ?",
                     multipleChoice: false,
                     questionGroupId: professionalGroup.id),
            
            
            Question(content: "As-tu des crédits en cours (immobilier, auto, consommation…) ?",
                     multipleChoice: false,
                     questionGroupId: financialGroup.id),
            
            Question(content: "Quel est le montant total de tes charges mensuelles fixes ?",
                     multipleChoice: false,
                     questionGroupId: financialGroup.id),
            
            Question(content: "Mets-tu de l’argent de côté chaque mois ?",
                     multipleChoice: false,
                     questionGroupId: financialGroup.id),
            
    
            Question(content: "Es-tu propriétaire de ton logement principal ?",
                     multipleChoice: false,
                     questionGroupId: patrimonyGroup.id),
            
            Question(content: "Possèdes-tu d’autres biens immobiliers ?",
                     multipleChoice: false,
                     questionGroupId: patrimonyGroup.id),
            
            Question(content: "As-tu des placements financiers (PEL, assurance vie, bourse, crypto…) ?",
                     multipleChoice: false,
                     questionGroupId: patrimonyGroup.id),
            
            Question(content: "As-tu une épargne de précaution disponible ?",
                     multipleChoice: false,
                     questionGroupId: patrimonyGroup.id),
            
           
            Question(content: "As-tu un projet à court terme (1 à 3 ans) ?",
                     multipleChoice: false,
                     questionGroupId: objectivesGroup.id),
            
            Question(content: "As-tu un projet à moyen terme (3 à 7 ans) ?",
                     multipleChoice: false,
                     questionGroupId: objectivesGroup.id),
            
            Question(content: "As-tu un objectif à long terme (plus de 10 ans) ?",
                     multipleChoice: false,
                     questionGroupId: objectivesGroup.id),
            
         
            Question(content: "Comment réagis-tu face aux risques financiers ?",
                     multipleChoice: true,
                     questionGroupId: riskGroup.id),
            
            Question(content: "Accepterais-tu de voir tes placements baisser temporairement pour espérer plus de gains ?",
                     multipleChoice: false,
                     questionGroupId: riskGroup.id),
            
            Question(content: "Quel est ton horizon de placement ?",
                     multipleChoice: true,
                     questionGroupId: riskGroup.id),
            
           
            Question(content: "As-tu une assurance vie, invalidité ou décès ?",
                     multipleChoice: false,
                     questionGroupId: protectionGroup.id),
            
            Question(content: "As-tu une mutuelle ou complémentaire santé ?",
                     multipleChoice: false,
                     questionGroupId: protectionGroup.id),
            
            Question(content: "As-tu déjà prévu ta retraite (pension, PER, épargne retraite…) ?",
                     multipleChoice: false,
                     questionGroupId: protectionGroup.id)
        ]
        
        return questions
    }
}
