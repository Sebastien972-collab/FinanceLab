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
        try userCollection.document(id).setData(from: userData)
    }
    func fetchProfile(withId id: String) async throws -> UserData {
        try await userCollection.document(id).getDocument(as: UserData.self)
    }
    
    func updateProfile(withId id: String, userData: UserData) async throws -> UserData {
        try userCollection.document(id).setData(from: userData)
        return try await fetchProfile(withId: id)
    }
    func updateBalanceUser(withId id: String, balance: Double) async throws {
        try await userCollection.document(id).updateData(["balance": balance])
    }
    
    
    
}

enum DatabaseKey: String {
    case users =  "users"
    case transactions = "transactions"
    case projects = "projects"
}
