//
//  TransactionTests.swift
//  FinanceLab
//
//  Created by Anne Ferret on 30/10/2025.
//


import XCTest
@testable import FinanceLab

final class TransactionTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testTransaction_InitializesWithAllProperties() {
        // Given
        let id = UUID()
        let name = "Grocery Shopping"
        let icon = CategoryIcon.shoppingCartSimpleFill
        let amount = -45.50
        let date = Date()
        let contractor = "Whole Foods"
        
        // When
        let transaction = Transaction(
            id: id,
            name: name,
            iconName: icon,
            amount: amount,
            date: date,
            contractor: contractor
        )
        
        // Then
        XCTAssertEqual(transaction.id, id)
        XCTAssertEqual(transaction.name, name)
        XCTAssertEqual(transaction.iconName, icon)
        XCTAssertEqual(transaction.amount, amount)
        XCTAssertEqual(transaction.date, date)
        XCTAssertEqual(transaction.contractor, contractor)
    }
    
    func testTransaction_GeneratesUUIDByDefault() {
        // When
        let transaction1 = Transaction(
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 10.0,
            date: Date(),
            contractor: "Store"
        )
        let transaction2 = Transaction(
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 10.0,
            date: Date(),
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(transaction1.id, transaction2.id, "Each transaction should have a unique ID")
    }
    
    // MARK: - toTransactionData Tests
    
    func testToTransactionData_ConvertsAllPropertiesCorrectly() {
        // Given
        let id = UUID()
        let name = "Salary"
        let icon = CategoryIcon.handCoinsFill
        let amount = 2500.0
        let date = Date()
        let contractor = "Company Inc"
        
        let transaction = Transaction(
            id: id,
            name: name,
            iconName: icon,
            amount: amount,
            date: date,
            contractor: contractor
        )
        
        // When
        let transactionData = transaction.toTransactionData()
        
        // Then
        XCTAssertEqual(transactionData.id, id)
        XCTAssertEqual(transactionData.name, name)
        XCTAssertEqual(transactionData.iconName, icon.rawValue)
        XCTAssertEqual(transactionData.amount, amount)
        XCTAssertEqual(transactionData.date, date)
        XCTAssertEqual(transactionData.contractor, contractor)
    }
    
    func testToTransactionData_ConvertsIconToRawValue() {
        // Given
        let transaction = Transaction(
            name: "Test",
            iconName: .forkKnifeFill,
            amount: -30.0,
            date: Date(),
            contractor: "Restaurant"
        )
        
        // When
        let transactionData = transaction.toTransactionData()
        
        // Then
        XCTAssertEqual(transactionData.iconName, CategoryIcon.forkKnifeFill.rawValue)
        XCTAssertTrue(transactionData.iconName is String)
    }
    
    // MARK: - Equatable Tests
    
    func testTransaction_EqualityWithSameProperties() {
        // Given
        let id = UUID()
        let date = Date()
        let transaction1 = Transaction(
            id: id,
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let transaction2 = Transaction(
            id: id,
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertEqual(transaction1, transaction2)
    }
    
    func testTransaction_InequalityWithDifferentID() {
        // Given
        let date = Date()
        let transaction1 = Transaction(
            id: UUID(),
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let transaction2 = Transaction(
            id: UUID(),
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(transaction1, transaction2)
    }
    
    func testTransaction_InequalityWithDifferentName() {
        // Given
        let id = UUID()
        let date = Date()
        let transaction1 = Transaction(
            id: id,
            name: "Groceries",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let transaction2 = Transaction(
            id: id,
            name: "Shopping",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(transaction1, transaction2)
    }
    
    func testTransaction_InequalityWithDifferentAmount() {
        // Given
        let id = UUID()
        let date = Date()
        let transaction1 = Transaction(
            id: id,
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let transaction2 = Transaction(
            id: id,
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 100.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(transaction1, transaction2)
    }
    
    func testTransaction_InequalityWithDifferentIconName() {
        // Given
        let id = UUID()
        let date = Date()
        let transaction1 = Transaction(
            id: id,
            name: "Test",
            iconName: .shoppingCartSimpleFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let transaction2 = Transaction(
            id: id,
            name: "Test",
            iconName: .forkKnifeFill,
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(transaction1, transaction2, "Different iconNames should make transactions unequal")
    }
}
