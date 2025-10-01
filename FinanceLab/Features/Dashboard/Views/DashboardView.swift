//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {
    var healthScore: Double
    
    var body: some View {
        ScrollView {
            BudgetCard(healthScore: healthScore)
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    DashboardView(healthScore: 0.5)
}
