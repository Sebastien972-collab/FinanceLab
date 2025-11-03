//
//  QuestionProfileExtension.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

// Base de données de questions
extension Question {
    static var questionDatabase: [Question] {
        return [
            // Questions essentielles (l'application ne peut pas fonctionner sans)
            Question(
                label: "Revenus stables",
                content: "Quel est ton revenu net moyen (salaires, chômage etc.) ?",
                followUpLabel: "Montant moyen par mois",
                questionGroup: .essential
            ),
            Question(
                label: "Revenus complémentaires",
                content: "Quel est le montant de tes revenus complémentaires (rentes, aides diverses etc.) ?",
                followUpLabel: "Montant moyen par mois",
                questionGroup: .essential
            ),
            Question(
                label: "Crédits",
                content: "As-tu des crédits en cours (immobilier, auto, consommation etc.) ?",
                followUpLabel: "Montant moyen par mois",
                questionGroup: .essential
            ),
            Question(
                label: "Charges",
                content: "Quel est le montant de tes charges fixes (loyer, factures, abonnements etc.) ?",
                followUpLabel: "Montant moyen par mois",
                questionGroup: .essential
            ),
            Question(
                label: "Épargne",
                content: "Combien épargnes-tu (y compris précaution, projets etc.) ?",
                followUpLabel: "Montant moyen par mois",
                questionGroup: .essential
            ),
            
            // Situation personnelle et familiale
            Question(
                label: "Enfants",
                content: "Combien as-tu d'enfants à charge ?",
                followUpLabel: "Laisse zéro si tu n'en as pas",
                questionGroup: .personal
            ),
            Question(
                label: "Personnes à charge",
                content: "As-tu d’autres personnes à charge (parents, proches, etc.) ?",
                followUpLabel: "Combien ?",
                questionGroup: .personal
            ),
            Question(
                label: "Contributeurs",
                content: "À part toi, combien de personnes participent aux dépenses du foyer ?",
                followUpLabel: "Laisse zéro si tu es seul·e",
                questionGroup: .personal
            ),
            
            // Épargne de précaution
            Question(
                label: "Épargne de précaution",
                content: "Quel est le montant total de ton épargne de précaution disponible ?",
                followUpLabel: "Laisse zéro si tu n'as aucune épargne disponible",
                questionGroup: .savings
            ),
            
            // Protection & prévoyance
            Question(
                label: "Assurance vie",
                content: "À combien s'élève le montant de ton capital décès ?",
                followUpLabel: "Laisse zéro si tu n'as pas d'assurance vie",
                questionGroup: .protection
            ),
            Question(
                label: "Retraite",
                content: "Combien mets-tu de côté chaque mois en vue de ta retraite ?",
                followUpLabel: "Laisse zéro si tu ne mets rien de côté",
                questionGroup: .protection
            ),

            // Patrimoine existant NON ESSENTIEL
            Question(
                label: "Logement",
                content: "Si tu es propriétaire, quelle est la valeur de ton habitation principale ?",
                followUpLabel: "Si tu n'es pas propriétaire, laisse zéro",
                questionGroup: .patrimony
            ),
            Question(
                label: "Biens immobiliers",
                content: "Si tu possèdes d'autres biens immobiliers, quelle est leur valeur totale estimée ?",
                followUpLabel: "Laisse zéro si tu n'en possèdes pas",
                questionGroup: .patrimony
            ),
            Question(
                label: "Placements",
                content: "Quelle est la valeur de tes placements financiers (PEL, assurance vie, bourse, crypto…) ?",
                followUpLabel: "Laisse zéro si tu n'en possèdes pas",
                questionGroup: .patrimony
            ),

            // Gestion du risque & profil investisseur
            Question(
                label: "Tolérance",
                content: "Jusqu'à combien accepterais-tu de voir tes placements baisser temporairement pour espérer plus de gains ?",
                followUpLabel: "En pourcentage du placement initial",
                questionGroup: .risk
            ),
            Question(
                label: "Horizon",
                content: "À combien estimes-tu ton horizon de placement ?",
                followUpLabel: "En nombre d'années",
                questionGroup: .risk
            ),
        ]
    }
}
extension Question {

    var isRevenue: Bool {
        switch label.lowercased() {
        case let text where text.contains("revenu"):
            return true
        default:
            return false
        }
    }

    var isCharge: Bool {
        switch label.lowercased() {
        case let text where
            text.contains("crédit") ||
            text.contains("charge") ||
            text.contains("épargne"):
            return true
        default:
            return false
        }
    }

    static var revenueQuestions: [Question] {
        questionDatabase.filter { $0.isRevenue }
    }

    static var expenseQuestions: [Question] {
        questionDatabase.filter { $0.isCharge }
    }
}
