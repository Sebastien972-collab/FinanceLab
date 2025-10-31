//
//  DashboardViewModel.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 31/10/2025.
//

import Foundation
import FinanceCore

@Observable
class DashboardViewModel {
    let manager: UserManager = .shared
    var currentUser: User {
        manager.currentUser
    }
    var healthScore: Double = 0.0
    var monthlyRAS: Decimal = 0.0
    var dailyRAS: Decimal {
        monthlyRAS / 30
    }
    
    
    func setup()  {
        let rents = Decimal(string: UserStorage.shared.getUserString(forKey: .totalRent) ?? "") ?? 0
        let expenses = Decimal(string: UserStorage.shared.getUserString(forKey: .totalExpenses) ?? "") ?? 0
        let financialManager = FinancialProfileManager(revenues: rents, expenses: expenses)
        financialManager.calculateSavingDistribution()
        self.monthlyRAS = financialManager.ras
        
    }
    func calcul(answers : [Answer]) -> Double {
        var result: Double = 0
        for answer in answers {
            result += Double(answer.content) ?? 0
        }
        return result
    }
}
