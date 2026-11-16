//
//  DatabaseManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/02/2026.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    var db: Firestore {
        Firestore.firestore()
    }
    var userCollection: CollectionReference { db.collection(DatabaseKey.users.rawValue) }
    
    func createUser(withID id: String, userData: UserData) async throws {
        try await userCollection.document(id).setData(Firestore.Encoder().encode(userData))
    }
    func fetchProfile(withId id: String) async throws -> UserData {
        let snapshot = try await userCollection.document(id).getDocument()
        return try snapshot.data(as: UserData.self)
    }
    
    func updateProfile(withId id: String, userData: UserData) async throws -> UserData {
        try await userCollection.document(id).setData(Firestore.Encoder().encode(userData))
        return try await fetchProfile(withId: id)
    }
    func updateBalanceUser(withId id: String, balance: Double) async throws {
        try await userCollection.document(id).updateData(["balance": balance])
    }
    
    func updateFinancialProfileSummary(
        withId id: String,
        monthlyRevenue: Double,
        monthlyExpenses: Double,
        userCategory: String
    ) async throws {
        try await userCollection.document(id).updateData([
            "monthlyRevenue": monthlyRevenue,
            "monthlyExpenses": monthlyExpenses,
            "userCategory": userCategory
        ])
    }

    
    
}

enum DatabaseKey: String {
    case users =  "users"
    case transactions = "transactions"
    case projects = "projects"
}
