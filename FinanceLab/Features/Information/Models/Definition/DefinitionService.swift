//
//  DefinitionService.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 31/10/2025.
//

class DefinitionService {
    var keychain = KeychainService.shared
    var service = NetworkingService.shared
    
    func fetchDefinitions() async throws -> [Definition] {
        let token = try keychain.getToken()
        let definitionsRequest = APIRequest(endpoint: "/definitions/", httpMethod: .GET)
        let response = try await service.request(definitionsRequest, responseType: [DefinitionData].self, token: token)
        return response.map{ $0.toDefinition() }
    }
    
    func fetchRandomDefinition() async throws -> Definition {
        let token = try keychain.getToken()
        let randomDefinitionRequest = APIRequest(endpoint: "/definitions/random/", httpMethod: .GET)
        let response = try await service.request(randomDefinitionRequest, responseType: DefinitionData.self, token: token)
        return response.toDefinition()
    }
}
