//
//  BudgetCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct BudgetCard: View {
    var healthScore: Double
    
    var body: some View {
        StandardCard {
            VStack(spacing: 16) {
                Text(Date()
                    .formatted(.dateTime
                        .month(.wide)
                        .year()
                        .locale(Locale(identifier: "fr_FR")))
                        .capitalized)
                .font(.cardTitle)
                FinancialHealthView(healthScore: healthScore)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .foregroundStyle(Color.Text.primary)
        }
    }
}

#Preview {
    BudgetCard(healthScore: 0.5)
        .padding()
        .background {
            ZStack {
                BudgetCard(healthScore: 0.5).ignoresSafeArea()
                Rectangle()
                    .fill(Color.Card.background)
            }
        }
}
