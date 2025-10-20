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
    var service: NetworkingService = .shared
    func fetProjects(userId: String) async throws -> [Project] {
        guard let data = KeychainService.shared.read(service: "com.financelab.auth", account: "jwtToken"), let token = String(data: data, encoding: .utf8) else { throw LoginError.unknown  }
        let apiResquest = APIRequest(endpoint: "projects", httpMethod: .GET)
        let response = try await service.request(apiResquest, responseType: [ProjectData].self, token: token)
        return response.map {$0.toPrject()}
    }
}
