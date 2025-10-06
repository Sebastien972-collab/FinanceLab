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
    var error: Error = ProjectCreatorError.emptyFiels
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
        //        guard !name.isEmpty, !stringGoalAmount.isEmpty else { throw ProjectCreatorError.emptyFiels}
        //        let newProject = Project(name: name, currentImage: imageName, finalDate: finalDate, amount: goalAmount)
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
        after?()
        
    }
    
    private func createProject() -> Project {
        Project(name: name, currentImage: imageName, finalDate: finalDate, amount: goalAmount)
    }
    
    func check()  {
        guard !stringGoalAmount.isEmpty else {
            self.error = ProjectCreatorError.emptyFiels
            self.showError.toggle()
            return
        }
    }
}
