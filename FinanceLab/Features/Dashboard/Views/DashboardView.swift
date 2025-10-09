//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {
    var userName: String
    var userCategory: String
    var healthScore: Double
    var monthlyRAS: Double
    var dailyRAS: Double
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
//                    HStack {
//                        StandardCard {
//                            HStack {
//                                Circle()
//                                    .frame(width: 38, height: 38)
//                                VStack(alignment: .leading, spacing: 0) {
//                                    Text(userName)
//                                        .font(.body)
//                                    Text(userCategory)
//                                        .font(.listHeader)
//                                }
//                            }
//                        }
//                        .frame(width: 200)
//                        .foregroundStyle(Color.Text.primary)
//                    }
                    BudgetCard(
                        healthScore: healthScore,
                        monthlyRAS: monthlyRAS,
                        dailyRAS: dailyRAS
                    )
                }
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    
                }
            }
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    DashboardView(
        userName: "Jeanne Dupont",
        userCategory: "Bâtisseuse",
        healthScore: 0.5,
        monthlyRAS: 120,
        dailyRAS: 5.55
    )
}
