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
                VStack(alignment: .leading ,spacing: 32) {
                    UserCardProfile()
                    BudgetCard(
                        healthScore: healthScore,
                        monthlyRAS: monthlyRAS,
                        dailyRAS: dailyRAS
                    )
                    DemboCard() {
                        Text("Tu t'en sors bien ce mois-ci !")
                        Text("Tu veux en apprendre plus sur la gestion de ton argent ?")
                    }
                    NavigationLink(destination: TransactionListView()) {
                        Text("Je fais mes comptes !")
                    }
                        .buttonStyle(FinanceButton(state: .validate))
                }
                .padding()
            }
            .toolbar {

                ToolbarItem(placement: .primaryAction) {
                    Button("Nouvelle transaction", image: .circlesThreePlusFill) {
                        // action
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
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
