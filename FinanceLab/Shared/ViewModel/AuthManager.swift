//
//  AuthManager.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

@Observable
final class AuthManager {
    var currentUser: User = .guest
    private let service = NetworkingService.shared
    
    func create(email: String, password: String) async throws {
        try await authenticate(endpoint: "users", email: email, password: password)
    }
    
    func login(email: String, password: String) async throws {
        let credentials = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        let loginRequest = APIRequest(endpoint: "users/login", httpMethod: .POST, body: jsonData)
        
        let response = try await service.request(loginRequest, responseType: LoginResponse.self)
        
        // (Optionnel) stocker le token dans le Keychain
        //KeychainManager.shared.save(token: token)
        
        let profileRequest = APIRequest(endpoint: "users/profile", httpMethod: .GET)
        let userData = try await service.request(profileRequest, responseType: UserData.self, token: response.token)
        self.currentUser = userData.toUser()
    }
    
    private func authenticate(endpoint: String, email: String, password: String) async throws {
        let payload = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let apiRequest = APIRequest(endpoint: endpoint, httpMethod: .POST, body: jsonData)
        
        currentUser = try await service.request(apiRequest, responseType: User.self)
    }
}
