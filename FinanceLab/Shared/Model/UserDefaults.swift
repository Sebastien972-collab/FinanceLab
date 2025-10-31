//
//  UserDefaults.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 31/10/2025.
//

import Foundation

struct UserStorage {
    static let shared = UserStorage()
    private init() {}

    func saveUserString(_ value: String, forKey key: UserStorageKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func getUserString(forKey key: UserStorageKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
}

enum UserStorageKey: String {
case totalRent, totalExpenses
}
