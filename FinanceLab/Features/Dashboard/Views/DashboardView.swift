//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {
    var currentMonth: String = "Septembre 2025"
    var healthScore: Double = 0.8
    
    var body: some View {
        VStack {
            StandardCard {
                VStack(spacing: 16) {
                    Text(currentMonth)
                        .font(.cardTitle)
                    FinancialHealth(healthScore: healthScore)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .foregroundStyle(Color.Text.primary)
            }
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    DashboardView()
}
