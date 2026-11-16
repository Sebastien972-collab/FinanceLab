//
//  SavingsPocket.swift
//  FinanceLab
//
//  Created by Codex on 20/03/2026.
//

import Foundation
import FinanceCore

struct SavingsPocket: Identifiable {
    enum Kind: String, Identifiable {
        case precautionary
        case provision
        case longTerm
        case project

        var id: String { rawValue }
    }

    let kind: Kind
    let title: String
    let subtitle: String
    let icon: CategoryIcon
    let currentAmount: Decimal
    let targetAmount: Decimal
    let detail: String
    let targetLabel: String

    var id: Kind { kind }

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        let ratio = NSDecimalNumber(decimal: currentAmount / targetAmount).doubleValue
        return min(max(ratio, 0), 1)
    }
}


struct SavingsPlan {
    let pockets: [SavingsPocket]
    let profile: FinancialProfile
    let totalRecommended: Decimal
    let currentBalance: Decimal

    @MainActor
    static func make() -> SavingsPlan {
        make(customer: CustomerManager.shared.currentUser)
    }

    static func make(customer: Customer) -> SavingsPlan {
        let summary = customer.answers.isEmpty
            ? FinancialProfileSummary(
                monthlyRevenue: customer.monthlyRevenue,
                monthlyExpenses: customer.monthlyExpenses,
                profile: customer.userCategory
            )
            : FinancialProfileSummary.from(answers: customer.answers)

        let revenues = summary.monthlyRevenue
        let expenses = summary.monthlyExpenses
        let currentBalance = max(Decimal.zero, customer.balance)

        guard revenues > 0 || expenses > 0 else {
            return SavingsPlan(
                pockets: [],
                profile: .none,
                totalRecommended: 0,
                currentBalance: currentBalance
            )
        }

        let manager = summary.budget

        let totalRecommended = manager.amountSavedForSecurity
            + manager.savingProvide
            + manager.longTermSavings
            + manager.availableForSaving

        var pockets: [SavingsPocket] = []

        if manager.precautionarySavingsAmount > 0 {
            let declaredSavings = customer.answers.first { $0.question.isEmergencySavings }?.decimalValue ?? 0
            pockets.append(
                SavingsPocket(
                    kind: .precautionary,
                    title: "Épargne de précaution",
                    subtitle: "3 mois de dépenses pour absorber les imprévus",
                    icon: .bankFill,
                    currentAmount: max(0, declaredSavings),
                    targetAmount: manager.precautionarySavingsAmount,
                    detail: "Versement conseillé : \(manager.amountSavedForSecurity.roundedFormatted(0)) € / mois",
                    targetLabel: "objectif"
                )
            )
        }

        if manager.savingProvide > 0 {
            pockets.append(
                SavingsPocket(
                    kind: .provision,
                    title: "Épargne de prévoyance",
                    subtitle: "Ta poche de sécurité du mois selon FinanceCore",
                    icon: .handCoinsFill,
                    currentAmount: manager.savingProvide,
                    targetAmount: max(totalRecommended, manager.savingProvide),
                    detail: "Part mensuelle recommandée de ton budget d'épargne",
                    targetLabel: "budget"
                )
            )
        }

        if manager.longTermSavings > 0 {
            pockets.append(
                SavingsPocket(
                    kind: .longTerm,
                    title: "Épargne long terme",
                    subtitle: "Pour investir et construire dans la durée",
                    icon: .walletFill,
                    currentAmount: manager.longTermSavings,
                    targetAmount: max(totalRecommended, manager.longTermSavings),
                    detail: "Allocation mensuelle recommandée pour le long terme",
                    targetLabel: "budget"
                )
            )
        }

        if manager.availableForSaving > 0 {
            pockets.append(
                SavingsPocket(
                    kind: .project,
                    title: "Épargne projet",
                    subtitle: "Montant disponible pour alimenter tes objectifs",
                    icon: .targetFill,
                    currentAmount: manager.availableForSaving,
                    targetAmount: max(totalRecommended, manager.availableForSaving),
                    detail: "Budget mensuel mobilisable pour tes projets",
                    targetLabel: "budget"
                )
            )
        }

        return SavingsPlan(
            pockets: pockets,
            profile: manager.profile,
            totalRecommended: totalRecommended,
            currentBalance: currentBalance
        )
    }
}
