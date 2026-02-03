//
//  FinanceLabApp.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 25/09/2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct FinanceLabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var projectVM: ProjectViewModel = .init()
    @State private var tabVm = TabViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(projectVM)
                .environment(tabVm)
        }
    }
}
