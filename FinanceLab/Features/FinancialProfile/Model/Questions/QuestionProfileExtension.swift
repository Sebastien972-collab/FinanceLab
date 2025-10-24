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
                content: "Quel est ton revenu net (salaires, chômage etc.) ?",
                followUpLabel: "Moyenne par mois (en euros)",
                questionGroup: .essential
            ),
            Question(
                label: "Revenus complémentaires",
                content: "Quel est le montant de tes revenus complémentaires (rentes, aides diverses etc.) ?",
                followUpLabel: "Moyenne par mois (en euros)",
                questionGroup: .essential
            ),
            Question(
                label: "Crédits en cours",
                content: "As-tu des crédits en cours (immobilier, auto, consommation etc.) ?",
                followUpLabel: "Moyenne des remboursements par mois (en euros)",
                questionGroup: .essential
            ),
            Question(
                label: "Charges fixes",
                content: "Quel est le montant de tes charges fixes (loyer, factures, abonnements etc.) ?",
                followUpLabel: "Moyenne par mois (en euros)",
                questionGroup: .essential
            ),
            Question(
                label: "Épargnes",
                content: "Combien mets-tu de côté en épargnes (y compris précaution, projets etc.) ?",
                followUpLabel: "Moyenne par mois (en euros)",
                questionGroup: .essential
            ),
            
            // Situation personnelle et familiale
            Question(
                label: "Enfants à charge",
                content: "Combien as-tu d'enfants à charge ? Laisse zéro si tu n'en as pas.",
                followUpLabel: "Nombre",
                questionGroup: .personal
            ),
            Question(
                label: "Autres personnes à charge",
                content: "As-tu d’autres personnes à charge (parents, proches, etc.) ?",
                followUpLabel: "Nombre",
                questionGroup: .personal
            ),
            Question(
                label: "Contributeurs du foyer",
                content: "À part toi, combien de personnes participent aux dépenses du foyer ? Laisse zéro si tu es seul·e.",
                followUpLabel: "Nombre",
                questionGroup: .personal
            ),
            
            // Épargne de précaution
            Question(
                label: "Épargne de précaution",
                content: "Quel est le montant de ton épargne de précaution disponible actuellement ?",
                followUpLabel: "Montant total (en euros)",
                questionGroup: .savings
            ),
            
            // Protection & prévoyance
            Question(
                label: "Assurance vie",
                content: "À combien s'élève le montant de ton capital décès ?",
                followUpLabel: "Montant du capital décès (en euros)",
                questionGroup: .protection
            ),
            Question(
                label: "Retraite",
                content: "Combien mets-tu de côté chaque mois en vue de ta retraite ? Laisse zéro si tu ne mets rien de côté.",
                followUpLabel: "Montant mensuel (en euros)",
                questionGroup: .protection
            ),

            // Patrimoine existant NON ESSENTIEL
            Question(
                label: "Valeur du logement",
                content: "Si tu es propriétaire, quelle est la valeur de ton habitation principale ? Laisse zéro si inapplicable.",
                followUpLabel: "Montant (en euros)",
                questionGroup: .patrimony
            ),
            Question(
                label: "Autres biens immobiliers",
                content: "Si tu possèdes d'autres biens immobiliers, quelle est leur valeur totale estimée ? Laisse zéro si inapplicable.",
                followUpLabel: "Montant (en euros)",
                questionGroup: .patrimony
            ),
            Question(
                label: "Placements",
                content: "Quelle est la valeur de tes placements financiers (PEL, assurance vie, bourse, crypto…) ? Laisse zéro si inapplicable.",
                followUpLabel: "Montant total (en euros)",
                questionGroup: .patrimony
            ),

            // Gestion du risque & profil investisseur
            Question(
                label: "Tolérance au risque",
                content: "Jusqu'à combien accepterais-tu de voir tes placements baisser temporairement pour espérer plus de gains ?",
                followUpLabel: "Pourcentage de perte acceptable",
                questionGroup: .risk
            ),
            Question(
                label: "Horizon de placement",
                content: "À combien estimes-tu ton horizon de placement ?",
                followUpLabel: "Nombre d'années",
                questionGroup: .risk
            ),
        ]
    }
    
//    static var unusedQuestions: [Question] = [
//        Question(label: "Statut", content: "Es-tu marié(e), pacsé(e) ou célibataire ?", questionGroup: .personal),
//        Question(label: "Emploi", content: "Quelle est ta situation professionnelle ?", questionGroup: .professional),
//    Question(
//        label: "Risque",
//        content: "Comment réagis-tu face aux risques financiers ?",
//        questionGroup: .risk
//    ),
//    Question(
//        label: "Santé",
//        content: "As-tu une mutuelle ou complémentaire santé ?",
//        questionGroup: .protection
//    ),
//    ]
}
