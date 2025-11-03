//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {
    @State private var dashboardVM: DashboardViewModel = .init()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    UserCardProfile()
                        .frame(maxWidth: 260)
                    BudgetCard(
                        healthScore: dashboardVM.healthScore,
                        monthlyRAS: dashboardVM.monthlyRAS,
                        dailyRAS: dashboardVM.dailyRAS
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
            .background {
                FinancialBackground().ignoresSafeArea()
            }
            .onAppear {
                dashboardVM.setup()
            }
        }
    }
}

#Preview {
    DashboardView()
}
