//
//  Gradients.swift
//  FinanceLab
//
//  Created by Anne Ferret on 25/09/2025.
//

import SwiftUI

// Use gradients in your views like in the following exemple :
//
// Rectangle()
//     .fill(LinearGradient.redGradient)

extension LinearGradient {
    static let redGradient = LinearGradient(
        colors: [
            Color.Gradient.Red.start,
            Color.Gradient.Red.stop,
        ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    static let greenGradient = LinearGradient(
        colors: [
            Color.Gradient.Green.start,
            Color.Gradient.Green.stop,
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let primaryGradient = LinearGradient(
        colors: [
            Color.Gradient.Primary.start,
            Color.Gradient.Primary.stop,
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
