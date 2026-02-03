//
//  ProjectViewModel.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 30/09/2025.
//

import Foundation
import FinanceCore

@Observable
class ProjectViewModel {
    private(set) var projects: [Project] = []
    var error: Error = ProjectCreatorError.emptyFiels
    var showError: Bool = false
    var creatorMode: Bool = false
    var service: ProjectService = .shared
    var manager: CustomerManager = .shared
    
    func fetchProjects() async {
        do {
            self.projects = try await service.fetProjects()
        } catch  {
            launchError(withError: error)
        }
    }
    
    func addProject(_ project: Project) async {
        guard projects.contains(project) == false else { return}
        do {
            let newProject = try await service.addProject(project: project.toProjectData())
            self.projects.append(newProject.toProject())
            CustomerManager.shared.currentUser.projects = try await service.fetProjects()
        } catch  {
            launchError(withError: error)
        }
        
    }
    func remove(_ project: Project) async {
        guard projects.contains(project), let index = projects.firstIndex(of: project) else { return}
        do {
            try await service.removeProject(projectID: project.id.uuidString)
            projects.remove(at: index)
        } catch  {
            launchError(withError: error)
        }
       
    }
    
    func launchError(withError error: Error = LoginError.unknown) {
        self.error = error
        self.showError = true
    }
    
    func updateProject(with project: Project) async throws -> Project {
        return try await service.updatePrject(project: project.toProjectData())
    }
    
    
}
