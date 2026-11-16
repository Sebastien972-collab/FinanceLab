//
//  AccountViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//  Refactored by Sébastien DAGUIN (Développeur  IOS) 2026
//

import Foundation
import FirebaseFirestore

@MainActor
@Observable
class AccountViewModel {
    
    // Services
    private let service = TransactionService.shared
    private var monthStart = Date()
    private var cursor: DocumentSnapshot?
    var hasMoreHistory: Bool { cursor != nil }

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
        
        do {
            let today = Date()
            monthStart = Calendar.current.dateInterval(of: .month, for: today)?.start ?? today
            let recent = try await service.recentTransactions(since: monthStart)
            let history = try await service.history(before: monthStart, after: nil)
            transactionsList = recent + history.items
            cursor = history.next
            refreshCharts()
        } catch {
            handleError(error)
        }
    }

    func loadMoreHistory() async {
        guard let cursor, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await service.history(before: monthStart, after: cursor)
            let known = Set(transactionsList.map(\.id))
            transactionsList += page.items.filter { !known.contains($0.id) }
            self.cursor = page.next
        } catch {
            handleError(error)
        }
    }

    func save(_ entry: Transaction, editing: Bool) async throws {
        guard !isLoading else { throw CancellationError() }
        isLoading = true
        defer { isLoading = false }
        if editing {
            try await service.putTransaction(transaction: entry)
        } else {
            _ = try await service.postTransaction(transaction: entry)
        }
        transactionsList.removeAll { $0.id == entry.id }
        transactionsList.append(entry)
        transactionsList.sort { $0.date > $1.date }
        refreshCharts()
    }

    func deleteTransaction(_ id: UUID) async throws {
        guard !isLoading else { throw CancellationError() }
        isLoading = true
        defer { isLoading = false }
        try await service.deleteTransaction(id: id)
        transactionsList.removeAll { $0.id == id }
        refreshCharts()
    }

    private func refreshCharts() {
        calcSpendingRepartition()
        calcCategoryCharts()
    }

    // MARK: - Calculation Logic
    
    func calcCurrentMonthTransactions() -> [Transaction] {
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
    
    func calcSpendingRepartition() {
        let monthly = calcCurrentMonthTransactions()
        
        // Utilisation de reduce pour plus de performance et de lisibilité
        spent = monthly.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
        gained = monthly.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    
    func calcCategoryCharts() {
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
