//
//  LoginError.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 16/10/2025.
//
import Foundation

enum LoginError: Error, LocalizedError, Sendable {
    case invalidName(String? = nil)
    case invalidEmail(String? = nil)
    case invalidPassword
    case emptyFields
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidName(let name):
            return "Le nom « \(name ?? "") » est invalide."
            
        case .invalidEmail(let email):
            return "L'adresse email « \(email ?? "") » est invalide."
            
        case .invalidPassword:
            return """
            Mot de passe invalide.
            Il doit contenir au minimum 8 caractères, dont une majuscule, \
            une minuscule, un chiffre et un symbole.
            """
            
        case .emptyFields:
            return "Veuillez remplir tous les champs."
            
        case .unknown:
            return "Une erreur inattendue s'est produite. Veuillez réessayer."
        }
    }
}
