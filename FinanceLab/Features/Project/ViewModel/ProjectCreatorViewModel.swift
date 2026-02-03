//
//  ProjectCreatorManager.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//
//

import Foundation
import FinanceCore

@MainActor
@Observable
class ProjectCreatorViewModel {
    
    // MARK: - Form State
    var name: String = ""
    var startedDate: Date = .now
    var finalDate: Date = Calendar.current.date(byAdding: .month, value: 3, to: .now) ?? .now
    var finalDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: finalDate)
    }
    var stringGoalAmount: String = ""
    var selectedIcon: CategoryIcon = .targetFill
    
    // MARK: - UI State
    var isEditing: Bool = false
    var isLoading: Bool = false
    var error: Error = ProjectCreatorError.emptyFiels
    var showError: Bool = false
    
    // MARK: - Dependencies
    var manager: ProjectViewModel? // Référence faible ou injectée
    let service: ProjectService = .shared
    var projectToEdit: Project?
    
    // MARK: - Computed
    var goalAmount: Decimal {
        Decimal(string: stringGoalAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
    
    var isFormValid: Bool {
        !name.isEmpty && goalAmount > 0
    }
    
    // MARK: - Actions
    
    func validate(onSuccess: () -> Void) async {
        guard isFormValid else {
            handleError(ProjectCreatorError.emptyFiels)
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newProject = Project(
                name: name,
                finalDate: finalDate,
                amount: goalAmount
            )
            newProject.iconName = selectedIcon.rawValue
            
            // Appel via le ViewModel parent pour mettre à jour la liste globale
            if let manager = manager {
                await manager.addProject(newProject)
            } else {
                // Fallback direct service si pas de manager (cas rare)
                _ = try await service.addProject(project: newProject.toProjectData())
            }
            
            reset()
            onSuccess()
            
        } catch {
            handleError(error)
        }
    }
    
    func update(onSuccess: () -> Void) async {
        guard isFormValid, let project = projectToEdit else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Mise à jour de l'objet existant
            project.name = name
            project.goalAmount = goalAmount
            project.deadline = finalDate
            project.iconName = selectedIcon.rawValue
            
            // Persistance
            if let manager = manager {
                _ = try await manager.updateProject(with: project)
            } else {
                // _ = try await service.updateProject(project: project.toProjectData())
            }
            
            reset()
            onSuccess()
            
        } catch {
            handleError(error)
        }
    }
    
    // Pré-remplit le formulaire pour l'édition
    func setupForEditing(project: Project) {
        self.projectToEdit = project
        self.name = project.name
        self.stringGoalAmount = "\(project.goalAmount)"
        self.finalDate = project.deadline
        if let iconName = project.iconName {
            self.selectedIcon = CategoryIcon(rawValue: iconName) ?? .targetFill
        }
        self.isEditing = true
    }
    
    func reset() {
        name = ""
        stringGoalAmount = ""
        finalDate = Calendar.current.date(byAdding: .month, value: 3, to: .now) ?? .now
        selectedIcon = .targetFill
        projectToEdit = nil
        isEditing = false
        showError = false
    }
    
    func handleError(_ error: Error) {
        self.error = error
        self.showError = true
    }
}
