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
    var goalAmount: Decimal {
        convertStringToDecimal()
    }
    
    
    func recalculator() {
//        let newProject = Project(name: name, currentImage: imageName, finalDate: finalDate, amount: goalAmount)
//        newProject.feasibilityCalculation(availableSavingsCapacity)
    }
    func validate() {
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
}
