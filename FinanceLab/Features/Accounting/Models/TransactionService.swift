//
//  TransactionService.swift
//  FinanceLab
//
//  Created by Anne Ferret on 28/10/2025.
//

import Foundation

class TransactionService {
    var keychain = KeychainService.shared
    var service = NetworkingService.shared
    
    func fetchTransactions() async throws -> [Transaction] {
        let token = try keychain.getToken()
        let transactionRequest = APIRequest(endpoint: "/transactions/", httpMethod: .GET)
        let response = try await service.request(transactionRequest, responseType: [TransactionData].self, token: token)
        return response.map{ $0.toTransaction() }
    }
    
    func postTransaction(transaction: TransactionData) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(transaction)
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/transactions/", httpMethod: .POST, body: data)
        let _ = try await service.request(apiRequest, responseType: TransactionData.self, token: token)
    }
    
    func putTransaction(transaction: TransactionData) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(transaction)
        let token = try keychain.getToken()
        let apiRequest = APIRequest(endpoint: "/transactions/\(transaction.id.uuidString)", httpMethod: .PUT, body: data)
        let _ = try await service.request(apiRequest, responseType: TransactionData.self, token: token)
    }

}
