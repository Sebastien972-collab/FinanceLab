//
//  ProjectService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 20/10/2025.
//

import Foundation
import FinanceCore
class ProjectService {
    static let shared = ProjectService()
    private init() {}
    private let keychain: KeychainService = .shared
    var service: NetworkingService = .shared
    
    func fetProjects() async throws -> [Project] {
        let token = try keychain.getToken()
        print(token)
        let apiResquest = APIRequest(endpoint: "projects", httpMethod: .GET)
        let response = try await service.request(apiResquest, responseType: [ProjectData].self, token: token)
        return response.map {$0.toProject()}
    }
    
    func addProject(project: ProjectData) async throws -> ProjectData {
        let data = try JSONEncoder().encode(project)
        let token = try keychain.getToken()
        let apiResquest = APIRequest(endpoint: "projects", httpMethod: .POST, body: data)
        let response = try await service.request(apiResquest, responseType: ProjectData.self, token: token)
        return response
    }
    
    func removeProject(projectID: String) async throws {
        let token = try keychain.getToken()
        let apiResquest = APIRequest(endpoint: "projects/\(projectID)", httpMethod: .DELETE)
        _ = try await service.request(apiResquest, responseType: EmptyResponse.self, token: token)
    }
}
