//
//  TransactionTests.swift
//  FinanceLab
//
//  Created by Anne Ferret on 30/10/2025.
//


import Foundation
import Testing
@testable import FinanceLab

struct TransactionTests {
    
    // MARK: - Initialization Tests
    
    @Test func transaction_InitializesWithAllProperties() {
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
        #expect(transaction.id == id)
        #expect(transaction.name == name)
        #expect(transaction.iconName == icon)
        #expect(transaction.amount == amount)
        #expect(transaction.date == date)
        #expect(transaction.contractor == contractor)
    }
    
    @Test func transaction_GeneratesUUIDByDefault() {
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
        #expect(transaction1.id != transaction2.id, "Each transaction should have a unique ID")
    }
    
    // MARK: - toTransactionData Tests
    
    @Test func toTransactionData_ConvertsAllPropertiesCorrectly() {
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
        #expect(transactionData.id == id)
        #expect(transactionData.name == name)
        #expect(transactionData.iconName == icon.rawValue)
        #expect(transactionData.amount == amount)
        #expect(transactionData.date == date)
        #expect(transactionData.contractor == contractor)
    }
    
    @Test func toTransactionData_ConvertsIconToRawValue() {
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
        #expect(transactionData.iconName == CategoryIcon.forkKnifeFill.rawValue)
    }
    
    // MARK: - Equatable Tests
    
    @Test func transaction_EqualityWithSameProperties() {
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
        #expect(transaction1 == transaction2)
    }
    
    @Test func transaction_InequalityWithDifferentID() {
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
        #expect(transaction1 != transaction2)
    }
    
    @Test func transaction_InequalityWithDifferentName() {
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
        #expect(transaction1 != transaction2)
    }
    
    @Test func transaction_InequalityWithDifferentAmount() {
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
        #expect(transaction1 != transaction2)
    }
    
    @Test func transaction_InequalityWithDifferentIconName() {
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
        #expect(transaction1 != transaction2)
    }
}
