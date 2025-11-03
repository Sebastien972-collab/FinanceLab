//
//  AuthManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

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
    
    /// Crée un nouvel utilisateur puis récupère son profil.
    /// - Parameters:
    ///   - firstName: Prénom de l'utilisateur.
    ///   - lastName: Nom de l'utilisateur.
    ///   - email: Adresse e-mail.
    ///   - password: Mot de passe.
    /// - Returns: L'utilisateur courant (`User`) mappé depuis `UserData`.
    /// - Throws: Une erreur réseau ou d'encodage JSON.
    func create(firstName: String, lastName: String, email: String, password: String) async throws -> User {
        let credentials = ["id": UUID().uuidString,
                           "firstName": firstName,
                           "lastName": lastName,
                           "email": email,
                           "password": password]
        
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        // Appel API pour créer l'utilisateur, en envoyant les informations nécessaires.
        let apiRequest = APIRequest(endpoint: "users" , httpMethod: .POST, body: jsonData)
        let loginResponse = try await service.request(apiRequest, responseType: LoginResponse.self)
        // Stockage du token JWT dans le Trousseau pour les appels authentifiés suivants.
        if let data = loginResponse.token.data(using: .utf8) {
            KeychainService.shared.save(data: data, service: "com.financelab.auth", account: "jwtToken")
        }
        // Récupère le profil immédiatement après la création.
        return try await fetchProfile()
    }
    
    /// Authentifie l'utilisateur puis récupère son profil.
    /// - Parameters:
    ///   - email: Adresse e-mail.
    ///   - password: Mot de passe.
    /// - Returns: L'utilisateur courant (`User`).
    /// - Throws: Une erreur réseau ou d'encodage JSON.
    func login(email: String, password: String) async throws -> User {
        let credentials = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        let loginRequest = APIRequest(endpoint: "users/login", httpMethod: .POST, body: jsonData)
        
        let response = try await service.request(loginRequest, responseType: LoginResponse.self)
        
        // Sauvegarde du token JWT pour les futures requêtes authentifiées.
        if let data = response.token.data(using: .utf8) {
            KeychainService.shared.save(data: data, service: "com.financelab.auth", account: "jwtToken")
        }
        return try await fetchProfile()
    }
    
    /// Met à jour les informations du profil utilisateur.
    /// - Parameter userData: Données utilisateur à mettre à jour.
    /// - Returns: Le `User` mis à jour, ou `nil` si le token est manquant.
    /// - Throws: Une erreur réseau/JSON.
    func update(userData: UserData) async throws -> User?  {
        // Récupère le token depuis le Trousseau; si absent, on retourne `nil`.
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { return nil }
        let jsonData = try JSONSerialization.data(withJSONObject: userData)
        let loginRequest = APIRequest(endpoint: "users/update", httpMethod: .PATCH, body: jsonData)
        let response = try await service.request(loginRequest, responseType: UserData.self, token: token)
        return response.toUser()
    }
    
    /// Récupère le profil de l'utilisateur courant à partir de l'API.
    /// - Returns: Un objet `User` mappé depuis `UserData`.
    /// - Throws: Une erreur si le token est absent/expiré ou si l'appel échoue.
    func fetchProfile() async throws -> User  {
        // Récupération du token JWT depuis le Trousseau (obligatoire).
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"),  let token = String(data: data, encoding: .utf8) else {
            throw LoginError.unknown
        }
        
        let profileRequest = APIRequest(endpoint: "users/profile", httpMethod: .GET)
        let userData = try await service.request(profileRequest, responseType: UserData.self, token: token)
        return userData.toUser()
    }
    /// Vérifie localement l'expiration du token JWT via la claim `exp`.
    /// - Returns: `true` si le token est manquant, mal formé, ou expiré; `false` sinon.
    func isTokenExpired() -> Bool {
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { return true }
        let segments = token.split(separator: ".")
        guard segments.count >= 2 else { return true }

        let payloadSegment = String(segments[1])
        
        // Conversion base64url -> base64 standard pour décoder le payload.
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data),
              let dict = json as? [String: Any],
              let exp = dict["exp"] as? Double else {
            return true // on considère invalide si mal formé
        }

        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate < Date()
    }
    
    func logOut() {
        KeychainService.shared.deleteToken()
    }
}
