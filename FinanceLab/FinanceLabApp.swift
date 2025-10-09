//
//  FinanceLabApp.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 25/09/2025.
//

import SwiftUI

@main
struct FinanceLabApp: App {
    @State private var projectVM: ProjectViewModel = .init()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(projectVM)
        }
    }
}
