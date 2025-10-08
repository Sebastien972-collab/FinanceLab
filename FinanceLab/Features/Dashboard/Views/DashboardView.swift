//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {
    var healthScore: Double
    var monthlyRAS: Double
    var dailyRAS: Double
    
    var body: some View {
        ScrollView {
            BudgetCard(
                healthScore: healthScore,
                monthlyRAS: monthlyRAS,
                dailyRAS: dailyRAS
            )
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    DashboardView(healthScore: 0.5, monthlyRAS: 120, dailyRAS: 5.55)
}
