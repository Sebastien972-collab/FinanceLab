//
//  KeychainService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 16/10/2025.
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    private init() {}
    
    func save(data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Keychain Save Error: \(status)")
        }
    }
    
    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("Keychain Read Error: \(status)")
            return nil
        }
    }
    
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print(" Keychain Delete Error: \(status)")
        }
    }
    
     func getToken() throws -> String {
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { throw LoginError.unknown  }
        return token
    }
    
    
}
