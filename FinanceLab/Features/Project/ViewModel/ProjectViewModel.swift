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
    
    func fetchProjects() async {
        do {
            self.projects = try await service.fetchProjects()
        } catch  {
            launchError(withError: error)
        }
    }
    
    func addProject(_ project: Project) async throws {
        let created = try await service.addProject(project: project.toProjectData())
        projects.removeAll { $0.id == created.id }
        projects.append(created.toProject())
    }

    func contribute(_ amount: Decimal, to project: Project, operationID: UUID) async throws {
        guard amount > 0 else { throw ProjectCreatorError.emptyFiels }
        let expense = Transaction(id: operationID, name: "Épargne projet", iconName: .targetFill,
                                  amount: -amount.toDoucble(), date: .now, contractor: project.name)
        guard let saved = try await TransactionService.shared.postTransaction(transaction: expense, projectID: project.id) else {
            throw LoginError.custom("Le montant de la cagnotte est indisponible.")
        }
        project.amountSaved = saved
        projects.first { $0.id == project.id }?.amountSaved = saved
    }

    func remove(_ project: Project) async {
        guard projects.contains(where: { $0.id == project.id }) else { return }
        do {
            try await service.removeProject(projectID: project.id.uuidString)
            projects.removeAll { $0.id == project.id }
        } catch  {
            launchError(withError: error)
        }
       
    }
    
    func launchError(withError error: Error = LoginError.unknown) {
        self.error = error
        self.showError = true
    }
    
    func updateProject(with project: Project) async throws -> Project {
        let updatedProjectData = try await service.updateProject(project: project.toProjectData())
        let updatedProject = updatedProjectData.toProject()
        
        if let index = self.projects.firstIndex(where: { $0.id == updatedProject.id }) {
            self.projects[index] = updatedProject
        }
        
        return updatedProject
    }
}
