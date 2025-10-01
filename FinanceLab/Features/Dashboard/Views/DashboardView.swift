//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {

    var healthScore: Double = 0.5
    
    var body: some View {
        ScrollView {
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
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    DashboardView()
}
