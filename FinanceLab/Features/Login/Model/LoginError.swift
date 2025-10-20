//
//  LoginError.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 16/10/2025.
//

import Foundation


enum LoginError: Error, LocalizedError, Sendable {
    case invalidName(String? = nil)
    case ivalidEmail(String? = nil)
    case unknown
    case emptyFiels
    
    /// Message par défaut pour LocalizedError
    public var errorDescription: String? {
        switch self {
        case .invalidName(let name):
            return "Le nom: \(name ?? "") est invalide."
            case .ivalidEmail(let email):
            return "L'email: \(email ?? "") est invalide."
        case .unknown:
            return "Une erreur inattendue s'est produite."
        case .emptyFiels:
            return "Veuillez remplir tous les champs."
        }
    }
}
