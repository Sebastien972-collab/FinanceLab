//
//  AuthService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

class NetworkingService {
    static let shared = NetworkingService()
    private init(){}
    
    func request<T: Decodable>(_ apiRequest: APIRequest, reponseType: T.Type, token: String? = nil) async throws -> T {
        guard let url = URL(string: "http://127.0.0.1:8080\(apiRequest.endpoint)") else { throw URLError.init(.badURL) }
        var request:  URLRequest = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = apiRequest.body {
            request.httpBody = body
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
        
    }
}
