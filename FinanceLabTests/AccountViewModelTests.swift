//
//  AccountViewModelTests.swift
//  FinanceLab
//
//  Created by Anne Ferret on 30/10/2025.
//


import XCTest
@testable import FinanceLab

final class AccountViewModelTests: XCTestCase {
    
    var viewModel: AccountViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AccountViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - calcCurrentMonthTransactions Tests
    
    func testCalcCurrentMonthTransactions_WithCurrentMonthTransactions_ReturnsOnlyCurrentMonth() {
        // Given
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
        XCTAssertEqual(result.count, 2, "Should only return current month transactions")
        XCTAssertTrue(result.contains(where: { $0.name == "Current 1" }))
        XCTAssertTrue(result.contains(where: { $0.name == "Current 2" }))
        XCTAssertFalse(result.contains(where: { $0.name == "Last Month" }))
    }
    
    func testCalcCurrentMonthTransactions_WithEmptyList_ReturnsEmptyArray() {
        // Given
        viewModel.transactionsList = []
        
        // When
        let result = viewModel.calcCurrentMonthTransactions()
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when no transactions")
    }
    
    func testCalcCurrentMonthTransactions_WithDifferentYears_OnlyReturnsCurrentYear() {
        // Given
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
        XCTAssertEqual(result.count, 1, "Should only return current year and month")
        XCTAssertEqual(result.first?.name, "This Year")
    }
    
    // MARK: - calcSpendingRepartition Tests
    
    func testCalcSpendingRepartition_WithNegativeTransactions_CalculatesCorrectSpent() {
        // Given
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
        XCTAssertEqual(viewModel.spent, 85.5, "Should sum all negative amounts as positive")
    }
    
    func testCalcSpendingRepartition_WithPositiveTransactions_CalculatesCorrectGained() {
        // Given
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
        XCTAssertEqual(viewModel.gained, 1750.75, "Should sum all positive amounts")
    }
    
    func testCalcSpendingRepartition_WithMixedTransactions_CalculatesBothCorrectly() {
        // Given
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
        XCTAssertEqual(viewModel.spent, 75.5)
        XCTAssertEqual(viewModel.gained, 1500.0)
    }
    
    func testCalcSpendingRepartition_WithEmptyTransactions_BothAreZero() {
        // Given
        viewModel.transactionsList = []
        
        // When
        viewModel.calcSpendingRepartition()
        
        // Then
        XCTAssertEqual(viewModel.spent, 0)
        XCTAssertEqual(viewModel.gained, 0)
    }
    
    func testCalcSpendingRepartition_OnlyCountsCurrentMonth() {
        // Given
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
        XCTAssertEqual(viewModel.spent, 50.0, "Should only count current month")
    }
    
    func testCalcSpendingRepartition_WithZeroAmounts_HandlesCorrectly() {
        // Given
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
        XCTAssertEqual(viewModel.spent, 10.0, accuracy: 0.01)
        XCTAssertEqual(viewModel.gained, 0.0)
    }
    
    // MARK: - calcCategoryCharts Tests
    
    func testCalcCategoryCharts_WithNegativeTransactions_GroupsByIcon() {
        // Given
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
        XCTAssertEqual(viewModel.transactionsChartSpent.count, 2)
        
        let foodCategory = viewModel.transactionsChartSpent.first(where: { $0.icon == .carrotFill })
        XCTAssertNotNil(foodCategory, "Food category should exist")
        XCTAssertEqual(foodCategory!.amount, 50.0)
        
        let cartCategory = viewModel.transactionsChartSpent.first(where: { $0.icon == .shoppingCartSimpleFill })
        XCTAssertNotNil(cartCategory, "Cart category should exist")
        XCTAssertEqual(cartCategory!.amount, 50.0)
    }
    
    func testCalcCategoryCharts_SortsSpentByAmountDescending() {
        // Given
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
        XCTAssertEqual(viewModel.transactionsChartSpent[0].icon, .shoppingCartSimpleFill)
        XCTAssertEqual(viewModel.transactionsChartSpent[0].amount, 100.0)
        XCTAssertEqual(viewModel.transactionsChartSpent[1].icon, .houseLineFill)
        XCTAssertEqual(viewModel.transactionsChartSpent[2].icon, .carrotFill)
    }
    
    func testCalcCategoryCharts_WithMoreThan5Categories_GroupsOthers() {
        // Given
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
        XCTAssertEqual(viewModel.transactionsChartSpent.count, 6, "Should have 5 categories plus Others")
        
        let othersCategory = viewModel.transactionsChartSpent.last
        XCTAssertEqual(othersCategory?.icon, .selectionFill)
        XCTAssertEqual(othersCategory?.amount, 15.0, "Others should sum the last 2 categories")
    }
    
    func testCalcCategoryCharts_WithPositiveTransactions_GroupsByIcon() {
        // Given
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
        XCTAssertEqual(viewModel.transactionsChartGained.count, 2)
        
        let euroCategory = viewModel.transactionsChartGained.first(where: { $0.icon == .currencyEurFill })
        XCTAssertEqual(euroCategory?.amount, 2500.0)
    }
    
    func testCalcCategoryCharts_OnlyCountsCurrentMonth() {
        // Given
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
        XCTAssertEqual(viewModel.transactionsChartSpent.count, 1)
        XCTAssertEqual(viewModel.transactionsChartSpent[0].amount, 50.0)
    }
    
    func testCalcCategoryCharts_WithEmptyTransactions_ReturnsEmptyCharts() {
        // Given
        viewModel.transactionsList = []
        
        // When
        viewModel.calcCategoryCharts()
        
        // Then
        XCTAssertTrue(viewModel.transactionsChartSpent.isEmpty)
        XCTAssertTrue(viewModel.transactionsChartGained.isEmpty)
    }
    
    func testCalcCategoryCharts_IgnoresZeroAmounts() {
        // Given
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
        XCTAssertEqual(viewModel.transactionsChartSpent.count, 1)
        XCTAssertEqual(viewModel.transactionsChartSpent[0].icon, .carrotFill)
    }
}
