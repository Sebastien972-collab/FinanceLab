//
//  LoginError.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 16/10/2025.
//
import Foundation

enum LoginError: LocalizedError {
    case unknown
    case emptyFields
    case invalidEmail
    case invalidPassword
    case differentPasswords
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .unknown: return "Une erreur inconnue est survenue."
        case .emptyFields: return "Veuillez remplir tous les champs obligatoires."
        case .invalidEmail: return "Le format de l'adresse email est invalide."
        case .invalidPassword: return "Le mot de passe doit contenir au moins 6 caractères."
        case .differentPasswords: return "Les mots de passe ne correspondent pas."
        case .custom(let message): return message
        }
    }
}
