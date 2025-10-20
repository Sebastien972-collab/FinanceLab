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
    
    func request<T: Decodable>(_ apiRequest: APIRequest, responseType: T.Type, token: String? = nil) async throws -> T {
        print("Je passe bien ICI ")
        print(apiRequest.endpoint)
        let stringUrl = "http://127.0.0.1:8080/\(apiRequest.endpoint)"
        print(stringUrl)
        guard let url = URL(string: stringUrl) else { throw URLError.init(.badURL) }
        print("📡 URL:", url.absoluteString)
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
        print(data)
        print("🧾 Réponse brute :", String(data: data, encoding: .utf8) ?? "Non décodable")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
        
    }
}
