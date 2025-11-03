//
//  AccountViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

@Observable
class AccountViewModel {
    // Services
    var manager: UserManager = .shared
    var service = TransactionService()
    
    // Affichage d'un message d'erreur explicite
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // Variables affichées dans les vues
    var transactionsList: [Transaction] = []
    var transactionsChartSpent: [(icon: CategoryIcon, amount: Double)] = []
    var transactionsChartGained: [(icon: CategoryIcon, amount: Double)] = []
    var spent: Double = 0
    var gained: Double = 0
    
    // Fonctions CRUD
    
    func fetchTransactions() async {
        do {
            transactionsList = try await service.fetchTransactions()
                .sorted(by: { $0.date > $1.date })
            manager.currentUser.transactions = transactionsList
        } catch {
            self.error = error
            showError.toggle()
            print("Error fetching transactions: \(error)")
        }
    }
    
    func postTransaction(_ transaction: Transaction) async {
        do {
            try await service.postTransaction(transaction: transaction.toTransactionData())
            try await manager.updateBalance(of: Decimal(transaction.amount))
        } catch {
            self.error = error
            showError.toggle()
            print("Error posting a new transaction: \(error)")
        }
    }
    
    func putTransaction(_ transaction: Transaction) async {
        do {
            try await service.putTransaction(transaction: transaction.toTransactionData())
        } catch {
            self.error = error
            showError.toggle()
            print("Error updating a transaction: \(error)")
        }
    }
    
    func deleteTransaction(_ id: UUID) async {
        do {
            try await service.deleteTransaction(id: id)
        } catch {
            self.error = error
            showError.toggle()
            print("Error deleting a transaction: \(error)")
        }
    }
    
    // Fonctions à lancer au chargement de la page TransactionListView()
    func initializeView() async {
        await fetchTransactions()
        calcSpendingRepartition()
        calcCategoryCharts()
    }
    
    // Fonctions de calcul diverses
    
    func calcCurrentMonthTransactions() -> [Transaction] {
        // Gets only the transactions from current month
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let monthlyTransactions = transactionsList.filter { transac in
            let transacMonth = Calendar.current.component(.month, from: transac.date)
            let transacYear = Calendar.current.component(.year, from: transac.date)
            return transacMonth == currentMonth && transacYear == currentYear
        }
        return monthlyTransactions
    }
    
    func calcSpendingRepartition() {
        let monthlyTransactions = calcCurrentMonthTransactions()
        
        // Return the sum of all negative transactions in the array (as an absolute)
        spent = 0
        for transac in monthlyTransactions {
            if transac.amount < 0 {
                spent += -transac.amount
            }
        }
        
        // Return the sum of all positive transactions in the array (as an absolute)
        gained = 0
        for transac in monthlyTransactions {
            if transac.amount > 0 {
                gained += transac.amount
            }
        }
    }
    
    func calcCategoryCharts() {
        let monthlyTransactions = calcCurrentMonthTransactions()
        
        // Takes only negative amounts, and group by icons
        transactionsChartSpent = Dictionary(grouping: monthlyTransactions.filter { $0.amount < 0 }, by: { $0.iconName })
            .map { (icon: $0.key, amount: $0.value.reduce(0) { $0 + abs($1.amount) }) }
            .sorted { $0.amount > $1.amount }
        
        // Group items beyond top 5 into "Others" category
        if transactionsChartSpent.count > 5 {
            let top5 = Array(transactionsChartSpent.prefix(5))
            let others = transactionsChartSpent.dropFirst(5)
            let othersTotal = others.reduce(0.0) { $0 + $1.amount }
            transactionsChartSpent = top5 + [(icon: .selectionFill, amount: othersTotal)]
        }
        
        // Now the same with only positive amounts
        transactionsChartGained = Dictionary(grouping: monthlyTransactions.filter { $0.amount > 0 }, by: { $0.iconName })
            .map { (icon: $0.key, amount: $0.value.reduce(0) { $0 + abs($1.amount) }) }
            .sorted { $0.amount > $1.amount }
        if transactionsChartGained.count > 5 {
            let top5 = Array(transactionsChartGained.prefix(5))
            let others = transactionsChartGained.dropFirst(5)
            let othersTotal = others.reduce(0.0) { $0 + $1.amount }
            transactionsChartGained = top5 + [(icon: .selectionFill, amount: othersTotal)]
        }
    }
}
