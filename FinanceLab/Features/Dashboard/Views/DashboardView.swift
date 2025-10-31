//
//  DashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct DashboardView : View {
    @State var profileVM = ProfileViewModel()
    
    var userName: String
    var userCategory: String
    var healthScore: Double
    var monthlyRAS: Double
    var dailyRAS: Double
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    NavigationLink {
                        UserProfileView(profilVM: profileVM)
                    } label: {
                        UserCardProfile()
                    }
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
