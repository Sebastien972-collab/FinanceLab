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
    var manager: ProjectCreatorManager = .init()
    var error: Error = ProjectCreatorError.emptyFiels
    var showError: Bool = false
    var creatorMode: Bool = false
    func fetchProjects() {
        projects = Project.previews
    }
    
    func addProject(_ project: Project) {
        guard !projects.contains(project) else { return }
        projects.append(project)
    }
    func remove(_ project: Project) {
        guard projects.contains(project), let index = projects.firstIndex(of: project) else { return }
        projects.remove(at: index)
    }
    
    
}
