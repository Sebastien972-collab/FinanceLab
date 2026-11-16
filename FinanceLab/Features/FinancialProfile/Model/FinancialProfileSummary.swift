//
//  FinancialProfileSummary.swift
//  FinanceLab
//
//  Created by Codex on 20/03/2026.
//

import Foundation
import FinanceCore

struct FinancialProfileSummary {
    let monthlyRevenue: Decimal
    let monthlyExpenses: Decimal
    let profile: FinancialProfile

    var budget: MonthlyBudget {
        MonthlyBudget(revenue: monthlyRevenue, expenses: monthlyExpenses)
    }

    static let empty = FinancialProfileSummary(
        monthlyRevenue: 0,
        monthlyExpenses: 0,
        profile: .none
    )

    static func from(answers: [Answer]) -> FinancialProfileSummary {
        guard !answers.isEmpty else { return .empty }

        let monthlyRevenue = answers
            .filter { $0.question.financialRole == .income }
            .reduce(Decimal.zero) { $0 + $1.decimalValue }

        let monthlyExpenses = answers
            .filter { $0.question.financialRole == .expense }
            .reduce(Decimal.zero) { $0 + $1.decimalValue }

        let budget = MonthlyBudget(revenue: monthlyRevenue, expenses: monthlyExpenses)

        return FinancialProfileSummary(
            monthlyRevenue: monthlyRevenue,
            monthlyExpenses: monthlyExpenses,
            profile: budget.profile
        )
    }
}

extension Answer {
    var decimalValue: Decimal {
        Decimal(string: content.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
}
