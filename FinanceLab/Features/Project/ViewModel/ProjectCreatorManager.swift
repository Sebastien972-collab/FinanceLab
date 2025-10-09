//
//  ProjectCreatorManager.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//

import Foundation
import FinanceCore

@Observable
class ProjectCreatorManager {
    var name: String = ""
    var startedDate: Date = .now
    var finalDate: Date =  .now
    var imageName: String = ""
    var stringGoalAmount: String = ""
    var error: LocalizedError = ProjectCreatorError.emptyFiels
    var showError: Bool = false
    var goalAmount: Decimal {
        convertStringToDecimal()
    }
    var finalDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: finalDate)
    }
    var isEditing: Bool = false
    var manager: ProjectViewModel = .init()
    var selectedIcon: CategoryIcon = .carFill
    
    func recalculator(_ asc : Decimal) {
        check()
        let createProject = self.createProject()
        let itsOk = createProject.feasibilityCalculation(asc)
        if itsOk {
        } else {
            self.error = ProjectCreatorError.insufficientFunds
        }
    }
     func validate() {
        check()
        let newProject = Project(name: name, currentImage: imageName, finalDate: finalDate, amount: goalAmount)
        manager.addProject(newProject)
         
        self.isEditing = false
        
    }
    private func convertStringToDecimal() -> Decimal {
        guard !stringGoalAmount.isEmpty else { return 0 }
        guard let decimal = Decimal(string: stringGoalAmount) else {
            if let intValue = Int(stringGoalAmount) {
                return Decimal(intValue)
            }
            return 0
        }
        return decimal
    }
    
    func reset(_ after: (() -> Void)? = nil) {
        name.removeAll()
        imageName.removeAll()
        stringGoalAmount.removeAll()
        self.isEditing = false
        after?()
        
        
    }
    
    private func createProject() -> Project {
        Project(name: name, currentImage: imageName, finalDate: finalDate, amount: goalAmount)
    }
    
    private func check()  {
        guard !name.isEmpty, !stringGoalAmount.isEmpty else {
            self.error = ProjectCreatorError.emptyFiels
            self.showError = true
            return
        }
    }
    func update(project: Project) {
        self.name = project.name
        self.startedDate = project.startedDate
        self.finalDate = project.deadline
        self.imageName = project.currentImage ?? ""
        self.stringGoalAmount = project.goalAmount.formatted()
        self.isEditing = true
    }
}
