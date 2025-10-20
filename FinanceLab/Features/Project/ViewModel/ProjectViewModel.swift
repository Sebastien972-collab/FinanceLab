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
    private(set) var projects: [Project] = Project.previews
    var error: Error = ProjectCreatorError.emptyFiels
    var showError: Bool = false
    var creatorMode: Bool = false
    var service: ProjectService = .shared
    var manager: UserManager = .shared
    func fetchProjects() async {
        do {
            self.projects = try await service.fetProjects(userId: manager.currentUser.id.uuidString)
        } catch  {
            self.error = error
            self.showError =  true
        }
    }
    
    func addProject(_ project: Project) {
        if projects.contains(project) {
            guard let index = projects.firstIndex(of: project) else { return }
            projects.remove(at: index)
            projects.append(project)
        } else {
            projects.append(project)
        }
        
    }
    func remove(_ project: Project) {
        guard projects.contains(project), let index = projects.firstIndex(of: project) else { return }
        projects.remove(at: index)
    }
    
    
    
}
