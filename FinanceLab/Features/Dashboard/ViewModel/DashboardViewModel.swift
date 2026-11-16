//
//  DashboardViewModel.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 31/10/2025.
//  Refactored by Gemini (Architecture Expert) 2026
//

import Foundation
import SwiftUI
import FinanceCore

@MainActor
@Observable
class DashboardViewModel {
    // Services
    private let manager: CustomerManager = .shared
    var currentUser: Customer { manager.currentUser }

    var userName: String {
        currentUser.firstName.isEmpty ? "Investisseur" : currentUser.firstName
    }

    var budget: MonthlyBudget {
        MonthlyBudget(revenue: currentUser.monthlyRevenue, expenses: currentUser.monthlyExpenses)
    }

    func refresh() async throws {
        try await manager.fetchProfile()
    }

    var monthlyRAS: Decimal { budget.spendable(balance: currentUser.balance) }
}
