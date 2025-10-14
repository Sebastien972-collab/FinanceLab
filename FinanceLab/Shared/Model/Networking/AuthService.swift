//
//  AuthManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

final class AuthService {
    private let shared = AuthService()
    private init() {}
    private let service = NetworkingService.shared
    
    func create(email: String, password: String) async throws -> User {
        try await authenticate(endpoint: "users", email: email, password: password)
    }
    
    func login(email: String, password: String) async throws -> User {
        let credentials = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        let loginRequest = APIRequest(endpoint: "users/login", httpMethod: .POST, body: jsonData)
        
        let response = try await service.request(loginRequest, responseType: LoginResponse.self)
        
        // (Optionnel) stocker le token dans le Keychain
        //KeychainManager.shared.save(token: token)
        
        let profileRequest = APIRequest(endpoint: "users/profile", httpMethod: .GET)
        let userData = try await service.request(profileRequest, responseType: UserData.self, token: response.token)
        return userData.toUser()
    }
    
    private func authenticate(endpoint: String, email: String, password: String) async throws -> User {
        let payload = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let apiRequest = APIRequest(endpoint: endpoint, httpMethod: .POST, body: jsonData)
        return try await service.request(apiRequest, responseType: UserData.self).toUser()
    }
}
