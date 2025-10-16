//
//  AuthManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

final class UserService {
    static let shared = UserService()
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
        print("TOKEN REÇU :", response.token)
        if let data = response.token.data(using: .utf8) {
            KeychainService.shared.save(data: data, service: "com.financelab.auth", account: "jwtToken")
        }
        
        let profileRequest = APIRequest(endpoint: "users/profile", httpMethod: .GET)
        let userData = try await service.request(profileRequest, responseType: UserData.self, token: response.token)
        return userData.toUser()
    }
    
    func update(userData: UserData) async throws -> User?  {
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { return nil }
        let jsonData = try JSONSerialization.data(withJSONObject: userData)
        let loginRequest = APIRequest(endpoint: "users/update", httpMethod: .PATCH, body: jsonData)
        let response = try await service.request(loginRequest, responseType: UserData.self, token: token)
        return response.toUser()
    }
    
    private func authenticate(endpoint: String, email: String, password: String) async throws -> User {
        let credentials = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        let apiRequest = APIRequest(endpoint: endpoint, httpMethod: .POST, body: jsonData)
        return try await service.request(apiRequest, responseType: UserData.self).toUser()
    }
}
