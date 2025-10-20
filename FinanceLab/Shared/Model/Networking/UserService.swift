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
        return try await fetchProfile()
    }
    
    func update(userData: UserData) async throws -> User?  {
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { return nil }
        let jsonData = try JSONSerialization.data(withJSONObject: userData)
        let loginRequest = APIRequest(endpoint: "users/update", httpMethod: .PATCH, body: jsonData)
        let response = try await service.request(loginRequest, responseType: UserData.self, token: token)
        return response.toUser()
    }
    
    func fetchProfile() async throws -> User  {
        guard  let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"),  let token = String(data: data, encoding: .utf8) else {
            throw LoginError.unknown
        }
        
        let profileRequest = APIRequest(endpoint: "users/profile", httpMethod: .GET)
        let userData = try await service.request(profileRequest, responseType: UserData.self, token: token)
        return userData.toUser()
    }
    func isTokenExpired() -> Bool {
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { return true }
        let segments = token.split(separator: ".")
        guard segments.count >= 2 else { return true }

        let payloadSegment = String(segments[1])
        
        // Décodage base64url → base64 standard
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
    
    private func authenticate(endpoint: String, email: String, password: String) async throws -> User {
        let credentials = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
        let apiRequest = APIRequest(endpoint: endpoint, httpMethod: .POST, body: jsonData)
        return try await service.request(apiRequest, responseType: UserData.self).toUser()
    }
}
