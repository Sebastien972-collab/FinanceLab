//
//  ApiRequest.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation

struct APIRequest {
    let endpoint: String
    let httpMethod: HTTPMethod
    var body: Data? = nil
}
