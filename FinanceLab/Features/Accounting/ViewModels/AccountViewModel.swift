//
//  AccountViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//  Refactored by Sébastien DAGUIN (Développeur  IOS) 2026
//

import Foundation

@MainActor
@Observable
class AccountViewModel {
    
    // Services
    private var manager: CustomerManager = .shared
    private var service = TransactionService.shared// Assurez-vous que ce service est thread-safe ou @MainActor
    
    // UI State
    var transactionsList: [Transaction] = []
    var transactionsChartSpent: [(icon: CategoryIcon, amount: Double)] = []
    var transactionsChartGained: [(icon: CategoryIcon, amount: Double)] = []
    var spent: Double = 0
    var gained: Double = 0
    
    var isLoading: Bool = false
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // MARK: - Actions
    
    func initializeView() async {
        isLoading = true
        defer { isLoading = false }
        
        await fetchTransactions()
        // Les calculs sont rapides, on peut les laisser sur le MainActor pour simplifier,
        // ou les passer en Task.detached si la liste est énorme.
        calcSpendingRepartition()
        calcCategoryCharts()
    }
    
    func fetchTransactions() async {
        do {
            transactionsList = try await service.fetchTransactions()
                .sorted(by: { $0.date > $1.date })
            manager.currentUser.transactions = transactionsList
        } catch {
            handleError(error)
        }
    }
    
    func postTransaction(_ transaction: Transaction) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await service.postTransaction(transaction: transaction)
            // Mise à jour optimiste ou re-fetch
            await fetchTransactions()
            // Recalcul des charts après ajout
            calcSpendingRepartition()
            calcCategoryCharts()
        } catch {
            handleError(error)
        }
    }
    
    func putTransaction(_ transaction: Transaction) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await service.putTransaction(transaction: transaction)
            await fetchTransactions()
            calcSpendingRepartition()
            calcCategoryCharts()
        } catch {
            handleError(error)
        }
    }
    
    func deleteTransaction(_ id: UUID) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await service.deleteTransaction(id: id)
            await fetchTransactions()
            calcSpendingRepartition()
            calcCategoryCharts()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Calculation Logic
    
    private func calcCurrentMonthTransactions() -> [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        return transactionsList.filter { transac in
            let tMonth = calendar.component(.month, from: transac.date)
            let tYear = calendar.component(.year, from: transac.date)
            return tMonth == currentMonth && tYear == currentYear
        }
    }
    
    private func calcSpendingRepartition() {
        let monthly = calcCurrentMonthTransactions()
        
        // Utilisation de reduce pour plus de performance et de lisibilité
        spent = monthly.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
        gained = monthly.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    
    private func calcCategoryCharts() {
        let monthly = calcCurrentMonthTransactions()
        
        // Helper interne pour éviter la duplication de code
        func processTransactions(_ transactions: [Transaction]) -> [(icon: CategoryIcon, amount: Double)] {
            let grouped = Dictionary(grouping: transactions, by: { $0.iconName })
                .map { (icon: $0.key, amount: $0.value.reduce(0) { $0 + abs($1.amount) }) }
                .sorted { $0.amount > $1.amount }
            
            if grouped.count > 5 {
                let top5 = Array(grouped.prefix(5))
                let othersTotal = grouped.dropFirst(5).reduce(0) { $0 + $1.amount }
                return top5 + [(icon: .selectionFill, amount: othersTotal)]
            }
            return grouped
        }
        
        transactionsChartSpent = processTransactions(monthly.filter { $0.amount < 0 })
        transactionsChartGained = processTransactions(monthly.filter { $0.amount > 0 })
    }
    
    private func handleError(_ error: Error) {
        self.error = error
        self.showError = true
    }
}
