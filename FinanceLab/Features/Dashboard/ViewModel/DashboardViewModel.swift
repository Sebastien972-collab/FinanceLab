//
//  DashboardViewModel.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 31/10/2025.
//  Refactored by Gemini (Architecture Expert) 2026
//

import Foundation
import SwiftUI
import FinanceCore

@MainActor
@Observable
class DashboardViewModel {
    // Services
    private let manager: CustomerManager = .shared
    private let storage: UserStorage = .shared
    
    // Data State
    var healthScore: Double = 0.5 // Valeur par défaut pour l'exemple
    var monthlyRAS: Decimal = 0.0
    
    var dailyRAS: Decimal {
        monthlyRAS / 30
    }
    
    var currentUser: Customer {
        manager.currentUser
    }
    
    var userName: String {
        currentUser.firstName.isEmpty ? "Investisseur" : currentUser.firstName
    }
    
    // Loading State
    var isLoading: Bool = false
    
    func setup() {
        isLoading = true
        // Simulation d'un petit chargement pour l'effet UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updatedRAS()
            self.isLoading = false
        }
    }
    
    private func updatedRAS() {
        // Récupération sécurisée des données
        let rentString = storage.getUserString(forKey: .totalRent) ?? "0"
        let expenseString = storage.getUserString(forKey: .totalExpenses) ?? "0"
        
        // Remplacement virgule par point pour sécurité conversion
        let safeRent = rentString.replacingOccurrences(of: ",", with: ".")
        let safeExpense = expenseString.replacingOccurrences(of: ",", with: ".")
        
        let rents = Decimal(string: safeRent) ?? 0
        let expenses = Decimal(string: safeExpense) ?? 0
        
        let financialManager = FinancialProfileManager(revenues: rents, expenses: expenses)
        financialManager.calculateSavingDistribution()
        
        // Calcul du RAS
        let computedMonthlyRAS = currentUser.balance - financialManager.availableForSaving - financialManager.bufferAmount - financialManager.longTermSavings
        monthlyRAS = max(0, computedMonthlyRAS)
        
        // Mise à jour score santé (Mock logique pour l'exemple)
        // Dans une vraie app, cela viendrait du FinancialManager
        healthScore = monthlyRAS > 0 ? 0.8 : 0.3
    }
}
