//
//  KeychainService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 16/10/2025.
//

import Foundation
import Security

/// A lightweight wrapper around the iOS Keychain for storing small sensitive values (e.g., tokens).
///
/// - Uses the generic password class (`kSecClassGenericPassword`).
/// - Provides simple CRUD operations: save, read, delete.
/// - Exposes convenience helpers to store and retrieve the app's auth token.
///
/// Note: Keychain operations return `OSStatus` codes. This wrapper logs failures
///       to aid debugging, but you may want to propagate errors in production.
class KeychainService {
    /// Shared singleton instance for convenient access throughout the app.
    static let shared = KeychainService()
    /// Private to enforce the singleton usage pattern.
    private init() {}
    /// Saves or updates a value in the Keychain.
    ///
    /// If an item with the same `service` and `account` already exists, it is deleted
    /// before inserting the new value.
    /// - Parameters:
    ///   - data: The raw data to save (e.g., UTF-8 encoded string).
    ///   - service: A reverse-DNS identifier grouping related credentials (e.g., "com.financelab.auth").
    ///   - account: The account identifier within the service (e.g., "jwtToken").
    func save(data: Data, service: String, account: String) {
        // Build a generic password query for this service/account
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        // Remove any existing item to perform an upsert-like behavior
        SecItemDelete(query as CFDictionary)
        // Insert the new value
        let status = SecItemAdd(query as CFDictionary, nil)
        // Log failures to help diagnose Keychain permission/config issues
        if status != errSecSuccess {
            print("Keychain Save Error: \(status)")
        }
    }
    
    /// Reads a single value from the Keychain.
    /// - Parameters:
    ///   - service: The service string used when saving the item.
    ///   - account: The account string used when saving the item.
    /// - Returns: The stored data if found, otherwise `nil`.
    func read(service: String, account: String) -> Data? {
        // Query the generic password for this service/account and return the data
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        // The Keychain API writes the result into this reference
        var dataTypeRef: AnyObject?
        // Perform the lookup
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // Cast the result to Data on success
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("Keychain Read Error: \(status)")
            return nil
        }
    }
    
    /// Deletes a value from the Keychain for the given service/account pair.
    /// - Parameters:
    ///   - service: The service string used when saving the item.
    ///   - account: The account string used when saving the item.
    func delete(service: String, account: String) {
        // Identify the item to delete
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        // Attempt deletion
        let status = SecItemDelete(query as CFDictionary)
        // Log if deletion failed (item may not exist)
        if status != errSecSuccess {
            print(" Keychain Delete Error: \(status)")
        }
    }
    
    /// Convenience helper to read the JWT token as a `String`.
    /// - Throws: `LoginError.unknown` if the token is missing or cannot be decoded as UTF-8.
    /// - Returns: The token string.
    func getToken() throws -> String {
        // Read the token from the shared Keychain entry and decode as UTF-8 string
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { throw LoginError.unknown  }
        return token
    }
    /// Convenience helper to delete the stored JWT token.
    func deleteToken() {
        delete(service: "com.financelab.auth", account: "jwtToken")
    }
}
