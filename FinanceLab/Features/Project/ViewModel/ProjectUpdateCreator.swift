//
//  ProjectUpdateManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 28/10/2025.
//

import Foundation
import FinanceCore

class ProjectUpdateCreator: ProjectCreatorViewModel {
    var idProject: UUID = .init()
    init(project: Project) {
        super.init()
        setupProject(project)
    
    }
    func validate(callback: (() -> Void)? = nil) async {
        do {
            let project = Project(name: name, iconName: selectedIcon.name, finalDate: finalDate, amount: goalAmount)
            project.id = idProject
            project.updateIcon(selectedIcon.rawValue)
            let projectData = try await service.updatePrject(project: project.toProjectData())
            setupProject(projectData)
        } catch  {
            handleError(error)
        }
    }
    
    
    
    func setupProject(_ project: Project) {
        idProject = project.id
        name = project.name
        startedDate = project.startedDate
        finalDate = project.deadline
        selectedIcon = CategoryIcon(rawValue: project.iconName ?? CategoryIcon.houseLineFill.rawValue) ?? .houseLineFill
        stringGoalAmount = project.formattedGoalAmount
        selectedIcon = CategoryIcon(rawValue: project.iconName ?? "") ?? .cakeFill
    }
}
