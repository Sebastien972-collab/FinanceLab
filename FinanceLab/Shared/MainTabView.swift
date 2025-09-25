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
    var body: some View {
        TabView {
            Tab("Mon budget", systemImage: "wallet.bifold.fill") {
                Text("Home")
            }
            Tab("Mes Projets", systemImage: "powermeter") {
                Text("Projets")
            }
            Tab("Ressources", systemImage: "newspaper.fill") {
                Text("S'informer")
            }
        }
    }
}

#Preview {
    MainTabView()
}
