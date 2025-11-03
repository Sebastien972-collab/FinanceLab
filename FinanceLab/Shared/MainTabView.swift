//
//  ContentView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 25/09/2025.
//

import SwiftUI

struct MainTabView: View {
    @Environment(TabViewModel.self) private var tabVm: TabViewModel
    var body: some View {
        @Bindable var tabVm = tabVm
        Group(content: {
            switch tabVm.authState {
            case .loading:
                ProgressView("Chargement...")
                    .task {
                        await tabVm.checkSession()
                    }
            case .authenticated:
                TabView {
                    Tab("Budget", systemImage: "wallet.bifold.fill") {
                        DashboardView()
                          .tag(TabViewModel.Selection.home)
                    }
                    Tab("Projets", systemImage: "powermeter") {
                        ProjectsView()
                            .tag(TabViewModel.Selection.project)
                    }
                    Tab("Ressources", systemImage: "newspaper.fill") {
                        InformationView()
                            .tag(TabViewModel.Selection.inform)
                    }
                    
                }
            case .notAuthenticated:
                LoginView(loginVM: LoginViewModel(), authState: $tabVm.authState)
            case .firstLaunch:
                OnboardingView()
                    .task {
                        do {
                            _ = try  await QuestionsService.shared.fetchQuestion()
                        } catch {
                            tabVm.launchError(error)
                        }
                    }
            case .questionPhase:
                FinancialQuestionView()
                
            }
        })
        .alert("Erreur", isPresented: $tabVm.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(tabVm.error?.localizedDescription ?? "Une erreur est survenue.")
        }
        .animation(.easeInOut, value: tabVm.authState)
        
    }
}

#Preview {
    MainTabView()
        .environment(ProjectViewModel())
        .environment(TabViewModel())
}
