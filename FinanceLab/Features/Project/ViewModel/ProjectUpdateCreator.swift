//
//  ProjectUpdateManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 28/10/2025.
//

import Foundation
import FinanceCore

class ProjectUpdateCreator: ProjectCreatorViewModel {
    init(project: Project) {
        super.init()
        setupProject(project)
    
    }
    override func validate() async {
        check()
        do {
            let project = Project(name: name, iconName: imageName, finalDate: finalDate, amount: goalAmount)
            project.updateIcon(selectedIcon.rawValue)
            let projectData = try await service.updatePrject(project: project.toProjectData())
            setupProject(projectData)
        } catch  {
            showError(error)
        }
    }
    
    
    
    func setupProject(_ project: Project) {
        name = project.name
        startedDate = project.startedDate
        finalDate = project.deadline
        imageName = project.iconName ?? CategoryIcon.houseLineFill.rawValue
        stringGoalAmount = project.formattedGoalAmount
    }
}
