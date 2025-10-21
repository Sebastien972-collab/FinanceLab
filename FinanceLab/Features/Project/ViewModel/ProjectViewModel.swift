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
            self.projects = try await service.fetProjects()
        } catch  {
            self.error = error
            self.showError =  true
        }
    }
    
    func addProject(_ project: Project) async {
        guard projects.contains(project) == false else { return}
        do {
            let newProject = try await service.addProject(project: project.toProjectData())
            self.projects.append(newProject.toProject())
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    func remove(_ project: Project) async {
        guard projects.contains(project), let index = projects.firstIndex(of: project) else { return}
        do {
            try await service.removeProject(projectID: project.id.uuidString)
            projects.remove(at: index)
        } catch  {
            self.error = error
            self.showError =  true
        }
       
    }
    
    
    
}
