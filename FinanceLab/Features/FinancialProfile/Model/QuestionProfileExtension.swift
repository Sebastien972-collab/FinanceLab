//
//  QuestionProfileExtension.swift
//  FinanceLab
//
//  Created by Dembo on 10/10/2025.
//

import Foundation

private enum QuestionCatalog {
    static let salary = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B001")!
    static let sideIncome = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B002")!
    static let fixedCharges = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B003")!
    static let credits = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B004")!
    static let committedSavings = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B005")!

    static let children = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B101")!
    static let dependents = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B102")!
    static let contributors = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B103")!

    static let emergencySavings = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B201")!

    static let lifeInsurance = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B301")!
    static let retirement = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B302")!

    static let primaryHome = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B401")!
    static let realEstate = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B402")!
    static let investments = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B403")!

    static let drawdownTolerance = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B501")!
    static let investmentHorizon = UUID(uuidString: "E6A1A9DA-9F67-42F8-BDB1-24CF43F8B502")!
}

// Base de données de questions
extension Question {
    static let questionDatabase: [Question] = [
            // Questions essentielles
            Question(
                id: QuestionCatalog.salary,
                label: "Revenus stables",
                content: "Quel est ton revenu net principal chaque mois ?",
                followUpLabel: "Salaire net mensuel",
                questionGroup: .essential,
                inputKind: .currency,
                financialRole: .income
            ),
            Question(
                id: QuestionCatalog.sideIncome,
                label: "Revenus complémentaires",
                content: "Combien reçois-tu en plus de ton revenu principal chaque mois ?",
                followUpLabel: "Aides, primes, rentes, extras...",
                questionGroup: .essential,
                inputKind: .currency,
                financialRole: .income
            ),
            Question(
                id: QuestionCatalog.fixedCharges,
                label: "Charges fixes",
                content: "Combien part chaque mois dans tes charges fixes ?",
                followUpLabel: "Loyer, factures, abonnements...",
                questionGroup: .essential,
                inputKind: .currency,
                financialRole: .expense
            ),
            Question(
                id: QuestionCatalog.credits,
                label: "Crédits",
                content: "Quel est le total de tes mensualités de crédit ?",
                followUpLabel: "Immobilier, auto, consommation...",
                questionGroup: .essential,
                inputKind: .currency,
                financialRole: .expense
            ),
            Question(
                id: QuestionCatalog.committedSavings,
                label: "Épargne engagée",
                content: "Quel montant mets-tu déjà de côté chaque mois ?",
                followUpLabel: "Épargne automatique, projets, retraite...",
                questionGroup: .essential,
                inputKind: .currency,
                financialRole: .expense
            ),
            
            // Situation personnelle et familiale
            Question(
                id: QuestionCatalog.children,
                label: "Enfants",
                content: "Combien as-tu d'enfants à charge ?",
                followUpLabel: "Laisse zéro si tu n'en as pas",
                questionGroup: .personal,
                inputKind: .count
            ),
            Question(
                id: QuestionCatalog.dependents,
                label: "Personnes à charge",
                content: "As-tu d’autres personnes à charge (parents, proches, etc.) ?",
                followUpLabel: "Combien ?",
                questionGroup: .personal,
                inputKind: .count
            ),
            Question(
                id: QuestionCatalog.contributors,
                label: "Contributeurs",
                content: "À part toi, combien de personnes participent aux dépenses du foyer ?",
                followUpLabel: "Laisse zéro si tu es seul·e",
                questionGroup: .personal,
                inputKind: .count
            ),
            
            // Épargne de précaution
            Question(
                id: QuestionCatalog.emergencySavings,
                label: "Épargne de précaution",
                content: "Quel est le montant total de ton épargne de précaution disponible ?",
                followUpLabel: "Laisse zéro si tu n'as aucune épargne disponible",
                questionGroup: .savings,
                inputKind: .currency
            ),
            
            // Protection & prévoyance
            Question(
                id: QuestionCatalog.lifeInsurance,
                label: "Assurance vie",
                content: "À combien s'élève le montant de ton capital décès ?",
                followUpLabel: "Laisse zéro si tu n'as pas d'assurance vie",
                questionGroup: .protection,
                inputKind: .currency
            ),
            Question(
                id: QuestionCatalog.retirement,
                label: "Retraite",
                content: "Combien mets-tu de côté chaque mois en vue de ta retraite ?",
                followUpLabel: "Laisse zéro si tu ne mets rien de côté",
                questionGroup: .protection,
                inputKind: .currency
            ),

            // Patrimoine existant
            Question(
                id: QuestionCatalog.primaryHome,
                label: "Logement",
                content: "Si tu es propriétaire, quelle est la valeur de ton habitation principale ?",
                followUpLabel: "Si tu n'es pas propriétaire, laisse zéro",
                questionGroup: .patrimony,
                inputKind: .currency
            ),
            Question(
                id: QuestionCatalog.realEstate,
                label: "Biens immobiliers",
                content: "Si tu possèdes d'autres biens immobiliers, quelle est leur valeur totale estimée ?",
                followUpLabel: "Laisse zéro si tu n'en possèdes pas",
                questionGroup: .patrimony,
                inputKind: .currency
            ),
            Question(
                id: QuestionCatalog.investments,
                label: "Placements",
                content: "Quelle est la valeur de tes placements financiers (PEL, assurance vie, bourse, crypto…) ?",
                followUpLabel: "Laisse zéro si tu n'en possèdes pas",
                questionGroup: .patrimony,
                inputKind: .currency
            ),

            // Gestion du risque & profil investisseur
            Question(
                id: QuestionCatalog.drawdownTolerance,
                label: "Tolérance",
                content: "Jusqu'à combien accepterais-tu de voir tes placements baisser temporairement pour espérer plus de gains ?",
                followUpLabel: "En pourcentage du placement initial",
                questionGroup: .risk,
                inputKind: .percentage
            ),
            Question(
                id: QuestionCatalog.investmentHorizon,
                label: "Horizon",
                content: "À combien estimes-tu ton horizon de placement ?",
                followUpLabel: "En nombre d'années",
                questionGroup: .risk,
                inputKind: .years
            ),
    ]
}
extension Question {
    var isEmergencySavings: Bool { id == QuestionCatalog.emergencySavings }

    var isRevenue: Bool { financialRole == .income }

    var isCharge: Bool { financialRole == .expense }

    static var revenueQuestions: [Question] { questionDatabase.filter { $0.isRevenue } }

    static var expenseQuestions: [Question] { questionDatabase.filter { $0.isCharge } }
}
