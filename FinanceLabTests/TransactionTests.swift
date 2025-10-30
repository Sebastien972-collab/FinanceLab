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

// MARK: - TransactionData Tests

final class TransactionDataTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testTransactionData_InitializesWithAllProperties() {
        // Given
        let id = UUID()
        let name = "Coffee"
        let iconName = "cheersFill"
        let amount = -5.50
        let date = Date()
        let contractor = "Starbucks"
        
        // When
        let transactionData = TransactionData(
            id: id,
            name: name,
            iconName: iconName,
            amount: amount,
            date: date,
            contractor: contractor
        )
        
        // Then
        XCTAssertEqual(transactionData.id, id)
        XCTAssertEqual(transactionData.name, name)
        XCTAssertEqual(transactionData.iconName, iconName)
        XCTAssertEqual(transactionData.amount, amount)
        XCTAssertEqual(transactionData.date, date)
        XCTAssertEqual(transactionData.contractor, contractor)
    }
    
    func testTransactionData_GeneratesUUIDByDefault() {
        // When
        let data1 = TransactionData(
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 10.0,
            date: Date(),
            contractor: "Store"
        )
        let data2 = TransactionData(
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 10.0,
            date: Date(),
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(data1.id, data2.id)
    }
    
    // MARK: - toTransaction Tests
    
    func testToTransaction_ConvertsAllPropertiesCorrectly() {
        // Given
        let id = UUID()
        let name = "Dinner"
        let iconName = CategoryIcon.forkKnifeFill.rawValue
        let amount = -65.00
        let date = Date()
        let contractor = "Restaurant"
        
        let transactionData = TransactionData(
            id: id,
            name: name,
            iconName: iconName,
            amount: amount,
            date: date,
            contractor: contractor
        )
        
        // When
        let transaction = transactionData.toTransaction()
        
        // Then
        XCTAssertEqual(transaction.id, id)
        XCTAssertEqual(transaction.name, name)
        XCTAssertEqual(transaction.iconName, .forkKnifeFill)
        XCTAssertEqual(transaction.amount, amount)
        XCTAssertEqual(transaction.date, date)
        XCTAssertEqual(transaction.contractor, contractor)
    }
    
    func testToTransaction_UsesDefaultIconForInvalidRawValue() {
        // Given
        let transactionData = TransactionData(
            name: "Test",
            iconName: "invalid.icon.name",
            amount: 50.0,
            date: Date(),
            contractor: "Store"
        )
        
        // When
        let transaction = transactionData.toTransaction()
        
        // Then
        XCTAssertEqual(transaction.iconName, .selectionFill, "Should use default icon for invalid raw value")
    }
    
    func testToTransaction_UsesCurrentDateWhenDateIsNil() {
        // Given
        var transactionData = TransactionData(
            name: "Test",
            iconName: CategoryIcon.shoppingCartSimpleFill.rawValue,
            amount: 50.0,
            date: Date(),
            contractor: "Store"
        )
        transactionData.date = nil
        
        let beforeConversion = Date()
        
        // When
        let transaction = transactionData.toTransaction()
        
        let afterConversion = Date()
        
        // Then
        XCTAssertGreaterThanOrEqual(transaction.date, beforeConversion)
        XCTAssertLessThanOrEqual(transaction.date, afterConversion)
    }
    
    // MARK: - Equatable Tests
    
    func testTransactionData_EqualityWithSameProperties() {
        // Given
        let id = UUID()
        let date = Date()
        let data1 = TransactionData(
            id: id,
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let data2 = TransactionData(
            id: id,
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertEqual(data1, data2)
    }
    
    func testTransactionData_InequalityWithDifferentID() {
        // Given
        let date = Date()
        let data1 = TransactionData(
            id: UUID(),
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let data2 = TransactionData(
            id: UUID(),
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(data1, data2)
    }
    
    func testTransactionData_InequalityWithDifferentIconName() {
        // Given
        let id = UUID()
        let date = Date()
        let data1 = TransactionData(
            id: id,
            name: "Test",
            iconName: "shoppingCartSimpleFill",
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        let data2 = TransactionData(
            id: id,
            name: "Test",
            iconName: "forkKnifeFill",
            amount: 50.0,
            date: date,
            contractor: "Store"
        )
        
        // Then
        XCTAssertNotEqual(data1, data2, "Different iconNames should make transaction data unequal")
    }
    
    // MARK: - Codable Tests
    
    func testTransactionData_EncodesToJSON() throws {
        // Given
        let date = Date()
        let transactionData = TransactionData(
            id: UUID(),
            name: "Test Transaction",
            iconName: "shoppingCartSimpleFill",
            amount: 99.99,
            date: date,
            contractor: "Test Store"
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(transactionData)
        
        // Then
        XCTAssertFalse(data.isEmpty, "Should encode to non-empty data")
    }
    
    func testTransactionData_DecodesFromJSON() throws {
        // Given
        let id = UUID()
        let date = Date()
        let original = TransactionData(
            id: id,
            name: "Test Transaction",
            iconName: "cart.fill",
            amount: 99.99,
            date: date,
            contractor: "Test Store"
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TransactionData.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.name, original.name)
        XCTAssertEqual(decoded.iconName, original.iconName)
        XCTAssertEqual(decoded.amount, original.amount, accuracy: 0.01)
        XCTAssertEqual(decoded.contractor, original.contractor)
    }
    
    func testTransactionData_RoundTripConversion() {
        // Given
        let original = Transaction(
            name: "Round Trip Test",
            iconName: .airplaneTiltFill,
            amount: -499.99,
            date: Date(),
            contractor: "Airline"
        )
        
        // When
        let transactionData = original.toTransactionData()
        let converted = transactionData.toTransaction()
        
        // Then
        XCTAssertEqual(converted.id, original.id)
        XCTAssertEqual(converted.name, original.name)
        XCTAssertEqual(converted.iconName, original.iconName)
        XCTAssertEqual(converted.amount, original.amount, accuracy: 0.01)
        XCTAssertEqual(converted.date, original.date)
        XCTAssertEqual(converted.contractor, original.contractor)
    }
}
