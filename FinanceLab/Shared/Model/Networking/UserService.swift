//
//  AuthManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation
import FirebaseAuth

/// Service utilisateur responsable des appels réseau liés à l'authentification et au profil.
///
/// - Fournit des méthodes pour créer un compte, se connecter, mettre à jour et récupérer le profil.
/// - Persiste le token JWT dans le Trousseau (Keychain) après authentification.
/// - S'appuie sur `NetworkingService` pour exécuter les requêtes HTTP.
final class UserService {
    /// Instance singleton pour un accès global.
    static let shared = UserService()
    /// Initialisation privée pour imposer le pattern singleton.
    private init() {}
    /// Couche réseau utilisée pour effectuer les requêtes.
    private let service = NetworkingService.shared
    private let authManager = AuthManager.shared
    private let databaseManager = DatabaseManager.shared
    
    /// Crée un nouvel utilisateur puis récupère son profil.
    /// - Parameters:
    ///   - firstName: Prénom de l'utilisateur.
    ///   - lastName: Nom de l'utilisateur.
    ///   - email: Adresse e-mail.
    ///   - password: Mot de passe.
    /// - Returns: L'utilisateur courant (`User`) mappé depuis `UserData`.
    /// - Throws: Une erreur réseau ou d'encodage JSON.
    func create(firstName: String, lastName: String, email: String, password: String) async throws -> Customer {
        let rents = Decimal(string: UserStorage.shared.getUserString(forKey: .totalRent) ?? "") ?? 0
        let expenses = Decimal(string: UserStorage.shared.getUserString(forKey: .totalExpenses) ?? "") ?? 0
        let credentials: [String: Any] = [
            "id": UUID().uuidString,
            "firstName": firstName,
            "lastName": lastName,
            "userCategory": "batisseur",
            "profilePictureURL": "",
            "email": email,
            "balance": rents.toDoucble() - expenses.toDoucble()
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        let userData: UserData = try JSONDecoder().decode(UserData.self, from: jsonData)
        let result = try await authManager.signUp(withEmail: email, password: password)
        // Appel API pour créer l'utilisateur, en envoyant les informations nécessaires.
        let userId = result.user.uid
        try await databaseManager.createUser(withID: userId, userData: userData)
        
        _ = try await updateBalance(balance: rents.toDoucble() - expenses.toDoucble())
        return try await fetchProfile(id: userId)
    }
    
    /// Authentifie l'utilisateur puis récupère son profil.
    /// - Parameters:
    ///   - email: Adresse e-mail.
    ///   - password: Mot de passe.
    /// - Returns: L'utilisateur courant (`User`).
    /// - Throws: Une erreur réseau ou d'encodage JSON.
    func login(email: String, password: String) async throws -> Customer {
        let result = try await authManager.signIn(withEmail: email, password: password)
        print(result.user.uid)
        return try await fetchProfile(id: result.user.uid)
    }
    
    /// Met à jour les informations du profil utilisateur.
    /// - Parameter userData: Données utilisateur à mettre à jour.
    /// - Returns: Le `User` mis à jour, ou `nil` si le token est manquant.
    /// - Throws: Une erreur réseau/JSON.
    func update(userData: UserData) async throws -> Customer?  {
        guard let userId =  Auth.auth().currentUser?.uid else { return nil }
        let response = try await databaseManager.updateProfile(withId: userId, userData: userData)
        return response.toUser()
    }
    
    func updateBalance(balance: Double) async throws -> Double {
        guard let userId =  Auth.auth().currentUser?.uid else { throw LoginError.unknown }
        try await databaseManager.updateBalaceUser(withId: userId, balance: balance)
        return balance
    }
    
    /// Récupère le profil de l'utilisateur courant à partir de l'API.
    /// - Returns: Un objet `User` mappé depuis `UserData`.
    /// - Throws: Une erreur si le token est absent/expiré ou si l'appel échoue.
    func fetchProfile(id: String) async throws -> Customer  {
        let userData = try await databaseManager.fetchProfile(withId: id)
        print("Les données de l'utilisateur sont: \(userData)")
        return userData.toUser()
    }
    /// Vérifie localement l'expiration du token JWT via la claim `exp`.
    /// - Returns: `true` si le token est manquant, mal formé, ou expiré; `false` sinon.
    func isTokenExpired() -> Bool {
        Auth.auth().currentUser != nil
    }
    
    func logOut() throws {
        try authManager.logout()
    }
}
