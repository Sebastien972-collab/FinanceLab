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
    override func validate(callback: (() -> Void)? = nil) async {
        check()
        do {
            let project = Project(name: name, iconName: imageName, finalDate: finalDate, amount: goalAmount)
            project.id = idProject
            project.updateIcon(selectedIcon.rawValue)
            let projectData = try await service.updatePrject(project: project.toProjectData())
            setupProject(projectData)
        } catch  {
            showError(error)
        }
    }
    
    
    
    func setupProject(_ project: Project) {
        idProject = project.id
        name = project.name
        startedDate = project.startedDate
        finalDate = project.deadline
        imageName = project.iconName ?? CategoryIcon.houseLineFill.rawValue
        stringGoalAmount = project.formattedGoalAmount
        selectedIcon = CategoryIcon(rawValue: project.iconName ?? "") ?? .cakeFill
    }
}
