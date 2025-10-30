//
//  AccountViewModelTests.swift
//  FinanceLab
//
//  Created by Anne Ferret on 30/10/2025.
//


import Foundation
import Testing
@testable import FinanceLab

struct AccountViewModelTests {
    
    // MARK: - calcCurrentMonthTransactions Tests
    
    @Test func calcCurrentMonthTransactions_WithCurrentMonthTransactions_ReturnsOnlyCurrentMonth() {
        
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Current 1",
                iconName: .selectionFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Last Month",
                iconName: .selectionFill,
                amount: -30.0,
                date: lastMonth,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Current 2",
                iconName: .selectionFill,
                amount: 100.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Next Month",
                iconName: .selectionFill,
                amount: -20.0,
                date: nextMonth,
                contractor: "Test contractor"
            )
        ]
        
        // When
        let result = viewModel.calcCurrentMonthTransactions()
        
        // Then
        #expect(result.count == 2, "Should only return current month transactions")
        #expect(result.contains { $0.name == "Current 1" })
        #expect(result.contains { $0.name == "Current 2" })
        #expect(!result.contains { $0.name == "Last Month" })
    }
    
    @Test func calcCurrentMonthTransactions_WithEmptyList_ReturnsEmptyArray() {
        // Given
        let viewModel = AccountViewModel()
        viewModel.transactionsList = []
        
        // When
        let result = viewModel.calcCurrentMonthTransactions()
        
        // Then
        #expect(result.isEmpty, "Should return empty array when no transactions")
    }
    
    @Test func calcCurrentMonthTransactions_WithDifferentYears_OnlyReturnsCurrentYear() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)!
        
        // Create a date in the same month but different year
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        components.year = (components.year ?? 2025) - 1
        let sameMonthLastYear = Calendar.current.date(from: components)!
        
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "This Year",
                iconName: .selectionFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Same Month Last Year",
                iconName: .selectionFill,
                amount: -30.0,
                date: sameMonthLastYear,
                contractor: "Test contractor"
            )
        ]
        
        // When
        let result = viewModel.calcCurrentMonthTransactions()
        
        // Then
        #expect(result.count == 1, "Should only return current year and month")
        #expect(result.first?.name == "This Year")
    }
    
    // MARK: - calcSpendingRepartition Tests
    
    @Test func calcSpendingRepartition_WithNegativeTransactions_CalculatesCorrectSpent() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Expense 1",
                iconName: .selectionFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Expense 2",
                iconName: .selectionFill,
                amount: -25.5,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Expense 3",
                iconName: .selectionFill,
                amount: -10.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        #expect(viewModel.spent == 85.5, "Should sum all negative amounts as positive")
    }
    
    @Test func calcSpendingRepartition_WithPositiveTransactions_CalculatesCorrectGained() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Income 1",
                iconName: .selectionFill,
                amount: 1000.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Income 2",
                iconName: .selectionFill,
                amount: 500.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Income 3",
                iconName: .selectionFill,
                amount: 250.75,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        #expect(viewModel.gained == 1750.75, "Should sum all positive amounts")
    }
    
    @Test func calcSpendingRepartition_WithMixedTransactions_CalculatesBothCorrectly() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Expense 1",
                iconName: .selectionFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Income 1",
                iconName: .selectionFill,
                amount: 1000.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Expense 2",
                iconName: .selectionFill,
                amount: -25.5,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Income 2",
                iconName: .selectionFill,
                amount: 500.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        #expect(viewModel.spent == 75.5)
        #expect(viewModel.gained == 1500.0)
    }
    
    @Test func calcSpendingRepartition_WithEmptyTransactions_BothAreZero() {
        // Given
        let viewModel = AccountViewModel()
        viewModel.transactionsList = []
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        #expect(viewModel.spent == 0)
        #expect(viewModel.gained == 0)
    }
    
    @Test func calcSpendingRepartition_OnlyCountsCurrentMonth() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Current Expense",
                iconName: .selectionFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Last Month Expense",
                iconName: .selectionFill,
                amount: -100.0,
                date: lastMonth,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        #expect(viewModel.spent == 50.0, "Should only count current month")
    }
    
    @Test func calcSpendingRepartition_WithZeroAmounts_HandlesCorrectly() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Zero",
                iconName: .selectionFill,
                amount: 0.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Expense",
                iconName: .selectionFill,
                amount: -10.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        #expect(viewModel.spent == 10.0)
        #expect(viewModel.gained == 0.0)
    }
    
    // MARK: - calcCategoryCharts Tests
    
    @Test func calcCategoryCharts_WithNegativeTransactions_GroupsByIcon() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Food 1",
                iconName: .carrotFill,
                amount: -30.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Food 2",
                iconName: .carrotFill,
                amount: -20.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Shopping",
                iconName: .shoppingCartSimpleFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcCategoryCharts()

        // Then
        let foodCategory = viewModel.transactionsChartSpent.first(where: { $0.icon == .carrotFill })
        let cartCategory = viewModel.transactionsChartSpent.first(where: { $0.icon == .shoppingCartSimpleFill })
        #expect(foodCategory != nil, "Food category should exist")
        #expect(foodCategory!.amount == 50.0)
        #expect(viewModel.transactionsChartSpent.count == 2)
        #expect(cartCategory != nil, "Cart category should exist")
        #expect(cartCategory!.amount == 50.0)
    }
    
    @Test func calcCategoryCharts_SortsSpentByAmountDescending() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Small",
                iconName: .carrotFill,
                amount: -10.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Large",
                iconName: .shoppingCartSimpleFill,
                amount: -100.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Medium",
                iconName: .houseLineFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcCategoryCharts()
        
        // Then
        #expect(viewModel.transactionsChartSpent[0].icon == .shoppingCartSimpleFill)
        #expect(viewModel.transactionsChartSpent[0].amount == 100.0)
        #expect(viewModel.transactionsChartSpent[1].icon == .houseLineFill)
        #expect(viewModel.transactionsChartSpent[2].icon == .carrotFill)
    }
    
    @Test func calcCategoryCharts_WithMoreThan5Categories_GroupsOthers() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Cat1",
                iconName: .shoppingCartSimpleFill,
                amount: -100.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Cat2",
                iconName: .carrotFill,
                amount: -90.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Cat3",
                iconName: .houseLineFill,
                amount: -80.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Cat4",
                iconName: .carFill,
                amount: -70.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Cat5",
                iconName: .airplaneTiltFill,
                amount: -60.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Cat6",
                iconName: .tShirtFill,
                amount: -10.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Cat7",
                iconName: .bicycleFill,
                amount: -5.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcCategoryCharts()
        
        // Then
        let othersCategory = viewModel.transactionsChartSpent.last
        #expect(viewModel.transactionsChartSpent.count == 6, "Should have 5 categories plus Others")
        #expect(othersCategory?.icon == .selectionFill)
        #expect(othersCategory?.amount == 15.0, "Others should sum the last 2 categories")
    }
    
    @Test func calcCategoryCharts_WithPositiveTransactions_GroupsByIcon() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Salary",
                iconName: .currencyEurFill,
                amount: 2000.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Bonus",
                iconName: .currencyEurFill,
                amount: 500.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Side Income",
                iconName: .handCoinsFill,
                amount: 300.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcCategoryCharts()
                
        // Then
        let euroCategory = viewModel.transactionsChartGained.first(where: { $0.icon == .currencyEurFill })
        #expect(viewModel.transactionsChartGained.count == 2)
        #expect(euroCategory?.amount == 2500.0)
    }
    
    @Test func calcCategoryCharts_OnlyCountsCurrentMonth() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Current",
                iconName: .shoppingCartSimpleFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Last Month",
                iconName: .shoppingCartSimpleFill,
                amount: -100.0,
                date: lastMonth,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcCategoryCharts()
        
        // Then
        #expect(viewModel.transactionsChartSpent.count == 1)
        #expect(viewModel.transactionsChartSpent[0].amount == 50.0)
    }
    
    @Test func calcCategoryCharts_WithEmptyTransactions_ReturnsEmptyCharts() {
        // Given
        let viewModel = AccountViewModel()
        viewModel.transactionsList = []
        
        // When
        viewModel.calcCategoryCharts()
        
        // Then
        #expect(viewModel.transactionsChartSpent.isEmpty)
        #expect(viewModel.transactionsChartGained.isEmpty)
    }
    
    @Test func calcCategoryCharts_IgnoresZeroAmounts() {
        // Given
        let viewModel = AccountViewModel()
        let currentDate = Date()
        viewModel.transactionsList = [
            Transaction(
                id: UUID(),
                name: "Zero",
                iconName: .shoppingCartSimpleFill,
                amount: 0.0,
                date: currentDate,
                contractor: "Test contractor"
            ),
            Transaction(
                id: UUID(),
                name: "Expense",
                iconName: .carrotFill,
                amount: -50.0,
                date: currentDate,
                contractor: "Test contractor"
            )
        ]
        
        // When
        viewModel.calcCategoryCharts()
        
        // Then
        #expect(viewModel.transactionsChartSpent.count == 1)
        #expect(viewModel.transactionsChartSpent[0].icon == .carrotFill)
    }
}
