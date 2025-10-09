//
//  ProjectViewModel.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 30/09/2025.
//

import Foundation
import FinanceCore

@Observable
final class ProjectViewModel {
    private(set) var projects: [Project] = []
    func fetchProjects() {
    }
    
    func add(_ project: Project) {
        guard !projects.contains(project) else { return }
    }
    func remove(_ project: Project) {
        guard projects.contains(project) else { return }
    }

    
}
