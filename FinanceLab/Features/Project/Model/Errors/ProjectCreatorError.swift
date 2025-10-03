//
//  ProjectCreatorError.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/10/2025.
//

import Foundation

public enum ProjectCreatorError: Error, LocalizedError, Sendable {
    case invalidAmount(Decimal)
    case dateNotAllowed
    case insufficientFunds
    case invalidName(String)
    case emptyFiels
    case unknown
    
    /// Message par défaut pour LocalizedError
    public var errorDescription: String? {
        switch self {
        case .invalidAmount(let amount):
            return "Le montant: \(amount) est invalide."
        case .dateNotAllowed:
            return "La date choisie n'est pas valide."
        case .unknown:
            return "Une erreur inattendue s'est produite."
        case .insufficientFunds:
            return "Fonds insuffisants pour ce projet."
        case .invalidName(let name):
            return "Le nom: \(name) est invalide."
        case .emptyFiels:
            return "Veuillez remplir tous les champs."
        }
    }
}

