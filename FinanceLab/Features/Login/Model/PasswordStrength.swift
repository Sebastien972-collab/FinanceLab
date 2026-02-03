//
//  PasswordStrength.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/02/2026.
//

import Foundation
import SwiftUI
enum PasswordStrength: String {
    case veryWeak = "Très faible"
    case weak = "Faible"
    case medium = "Correct"
    case strong = "Solide"
    case veryStrong = "Très solide"

    var score: Int {
        switch self {
        case .veryWeak: return 1
        case .weak: return 2
        case .medium: return 3
        case .strong: return 4
        case .veryStrong: return 5
        }
    }
    
    var color: Color {
        switch self {
        case .veryWeak: return .red
        case .weak: return .orange
        case .medium: return .yellow
        case .strong: return .green
        case .veryStrong: return Color.green.opacity(0.9)
        }
    }
}
