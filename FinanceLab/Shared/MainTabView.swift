//
//  ContentView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 25/09/2025.
//

import SwiftUI

struct MainTabView: View {
    private enum Selection {
        case home, project, inform
    }
    @State private var selection: Selection = .home
    @Environment(UserViewModel.self) private var userVM
    
    var body: some View {
        TabView {
            Tab("Mon budget", systemImage: "wallet.bifold.fill") {
                DashboardView(
                    userName: userVM.currentUser.displayName,
                       userCategory: "Bâtisseuse",
                       healthScore: 0.5,
                       monthlyRAS: 120,
                       dailyRAS: 5.55
                   )
            }
            Tab("Mes Projets", systemImage: "powermeter") {
                ProjectsView()
            }
            Tab("Ressources", systemImage: "newspaper.fill") {
                InformationView()
            }
        }
        .onAppear {
            Task {
                do {
                    try await userVM.login(email: "sebastien.daguin@financelab.com", password: "Sebby972")
                } catch {
                    print("Failed to update user: \(error)")
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(ProjectViewModel())
        .environment(UserViewModel())
    
}
