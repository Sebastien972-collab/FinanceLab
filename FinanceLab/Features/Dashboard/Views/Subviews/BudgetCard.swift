//
//  BudgetCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct BudgetCard: View {
    var healthScore: Double
    var monthlyRAS: Double
    var dailyRAS: Double
    
    var body: some View {
        StandardCard {
            VStack(spacing: 20) {
                Text(Date()
                    .formatted(.dateTime
                        .month(.wide)
                        .year()
                        .locale(Locale(identifier: "fr_FR")))
                        .capitalized)
                .font(.cardTitle)
                FinancialHealthView(healthScore: healthScore)
                RASView(monthlyRAS: monthlyRAS, dailyRAS: dailyRAS)
            }
            .padding()
            .foregroundStyle(Color.Text.primary)
        }
    }
}

#Preview {
    BudgetCard(healthScore: 0.5, monthlyRAS: 120, dailyRAS: 5.55)
        .padding()
        .background {
            ZStack {
                Rectangle()
                    .fill(Color.Card.background)
            }
        }
}
