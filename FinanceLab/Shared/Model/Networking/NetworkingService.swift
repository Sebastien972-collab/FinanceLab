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
        let stringUrl = "http://127.0.0.1:8080/\(apiRequest.endpoint)"
        guard let url = URL(string: ngrokURL) else { throw URLError.init(.badURL) }
        // Log the resolved URL for debugging (consider replacing with a proper logger in production).
        print("📡 URL:", url.absoluteString)
        var request:  URLRequest = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod.rawValue
        // Prepare headers: JSON content type and optional Authorization token.
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
        // Handle empty responses (e.g., HTTP 204 No Content). If the caller expects `EmptyResponse`, return it; otherwise throw.
        if httpResponse.statusCode == 204 || data.isEmpty {
            if let empty = EmptyResponse() as? T {
                return empty
            } else {
                throw URLError(.cannotParseResponse)
            }
        }
        
        // Raw data received; avoid logging binary payloads in production.
        // print(data)
        print("🧾 Réponse brute :", String(data: data, encoding: .utf8) ?? "Non décodable")
        // Decode JSON into the expected type using ISO-8601 for date fields.
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
        
    }
}

