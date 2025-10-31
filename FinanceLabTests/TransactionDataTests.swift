//
//  TransactionDataTests.swift
//  FinanceLab
//
//  Created by Anne Ferret on 30/10/2025.
//


import Foundation
import Testing
@testable import FinanceLab

struct TransactionDataTests {
    
    // MARK: - Initialization Tests
    
    @Test func transactionData_InitializesWithAllProperties() {
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
        #expect(transactionData.id == id)
        #expect(transactionData.name == name)
        #expect(transactionData.iconName == iconName)
        #expect(transactionData.amount == amount)
        #expect(transactionData.date == date)
        #expect(transactionData.contractor == contractor)
    }
    
    @Test func transactionData_GeneratesUUIDByDefault() {
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
        #expect(data1.id != data2.id)
    }
    
    // MARK: - toTransaction Tests
    
    @Test func toTransaction_ConvertsAllPropertiesCorrectly() {
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
        #expect(transaction.id == id)
        #expect(transaction.name == name)
        #expect(transaction.iconName == .forkKnifeFill)
        #expect(transaction.amount == amount)
        #expect(transaction.date == date)
        #expect(transaction.contractor == contractor)
    }
    
    @Test func toTransaction_UsesDefaultIconForInvalidRawValue() {
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
        #expect(transaction.iconName == .selectionFill, "Should use default icon for invalid raw value")
    }
    
    @Test func toTransaction_UsesCurrentDateWhenDateIsNil() {
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
        #expect(transaction.date >= beforeConversion)
        #expect(transaction.date <= afterConversion)
    }
    
    // MARK: - Equatable Tests
    
    @Test func transactionData_EqualityWithSameProperties() {
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
        #expect(data1 == data2)
    }
    
    @Test func transactionData_InequalityWithDifferentID() {
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
        #expect(data1 != data2)
    }
    
    @Test func transactionData_InequalityWithDifferentIconName() {
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
        #expect(data1 != data2, "Different iconNames should make transaction data unequal")
    }
    
    // MARK: - Codable Tests
    
    @Test func transactionData_EncodesToJSON() throws {
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
        #expect(!data.isEmpty, "Should encode to non-empty data")
    }
    
    @Test func transactionData_DecodesFromJSON() throws {
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
        #expect(decoded.id == original.id)
        #expect(decoded.name == original.name)
        #expect(decoded.iconName == original.iconName)
        #expect(decoded.amount == original.amount)
        #expect(decoded.contractor == original.contractor)
    }
    
    @Test func transactionData_RoundTripConversion() {
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
        #expect(converted.id == original.id)
        #expect(converted.name == original.name)
        #expect(converted.iconName == original.iconName)
        #expect(converted.amount == original.amount)
        #expect(converted.date == original.date)
        #expect(converted.contractor == original.contractor)
    }
}
