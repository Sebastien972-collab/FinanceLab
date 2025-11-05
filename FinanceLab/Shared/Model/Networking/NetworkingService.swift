//
//  AuthService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

/// A lightweight networking layer responsible for performing HTTP requests and decoding JSON responses.
///
/// - Provides a shared singleton `NetworkingService.shared` for convenience.
/// - Builds a `URLRequest` from an `APIRequest` abstraction (endpoint, method, body).
/// - Optionally attaches a Bearer token for authenticated calls.
/// - Uses `URLSession` with Swift concurrency (`async/await`).
/// - Decodes responses into the requested `Decodable` type using `JSONDecoder` (ISO-8601 dates).
///
/// Usage example:
/// ```swift
/// let user: User = try await NetworkingService.shared.request(.getUser(id: "123"), responseType: User.self, token: myJWT)
/// ```
///
/// Notes:
/// - Returns `EmptyResponse` when the server answers with HTTP 204 (No Content) or an empty body.
/// - Throws `URLError` for bad URLs or transport-level errors, and decoding errors if the payload doesn't match `T`.
class NetworkingService {
    /// Shared singleton instance for app-wide networking.
    static let shared = NetworkingService()
    /// Private initializer to enforce singleton usage.
    private init(){}
    
    /// Performs an HTTP request and decodes the JSON response into the given `Decodable` type.
    ///
    /// - Parameter apiRequest: High-level request descriptor containing endpoint, HTTP method, and optional body.
    /// - Parameter responseType: The concrete `Decodable` type expected in the response.
    /// - Parameter token: Optional Bearer token added as `Authorization` header when provided.
    /// - Returns: A decoded instance of `T` on success, or `EmptyResponse` when the server returns no content (204) and `T == EmptyResponse`.
    /// - Throws: `URLError` for bad URLs or transport errors, or decoding errors if the response body cannot be decoded to `T`.
    func request<T: Decodable>(_ apiRequest: APIRequest, responseType: T.Type, token: String? = nil) async throws -> T {
        let ngrokURL = "https://clare-bacteriologic-grimily.ngrok-free.dev/\(apiRequest.endpoint)"
        guard let url = URL(string: ngrokURL) else { throw URLError.init(.badURL) }

        print("📡 URL:", url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = apiRequest.body {
            request.httpBody = body
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // 204 No Content → retourner valeur vide si possible
        if httpResponse.statusCode == 204 || data.isEmpty {
            if let empty = [] as? T {
                return empty
            }
            if let empty = EmptyResponse() as? T {
                return empty
            }
            throw URLError(.cannotParseResponse)
        }

        print("🧾 Réponse brute :", String(data: data, encoding: .utf8) ?? "Non décodable")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            if let emptyArray = [] as? T {
                return emptyArray
            }
            throw error
        }
    }

}

