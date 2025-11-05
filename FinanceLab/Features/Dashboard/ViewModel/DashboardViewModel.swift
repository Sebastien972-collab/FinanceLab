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
    private let rents = Decimal(string: UserStorage.shared.getUserString(forKey: .totalRent) ?? "") ?? 0
    private let expenses = Decimal(string: UserStorage.shared.getUserString(forKey: .totalExpenses) ?? "") ?? 0
    
    
    func setup()  {
       updatedRAS()
    }
    func calcul(answers : [Answer]) -> Double {
        var result: Double = 0
        for answer in answers {
            result += Double(answer.content) ?? 0
        }
        return result
    }
    
    func updatedRAS() {
        let financialManager = FinancialProfileManager(revenues: rents, expenses: expenses)
        financialManager.calculateSavingDistribution()
        print(rents , expenses, currentUser.balance)
        print("Les montants sont : \(financialManager.availableForSaving) , \(financialManager.savingProvide) , \(financialManager.longTermSavings)")
        let computedMonthlyRAS = currentUser.balance - financialManager.availableForSaving - financialManager.bufferAmount - financialManager.longTermSavings
        monthlyRAS = max(0, computedMonthlyRAS)
    }
    
}
