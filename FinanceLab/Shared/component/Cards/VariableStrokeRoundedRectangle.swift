//
//  VariableStrokeRoundedRectangle.swift
//  FinanceLab
//
//  Created by Anne Ferret on 09/10/2025.
//

import SwiftUI

struct VariableStrokeRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    let topWidth: CGFloat
    let leadingWidth: CGFloat
    let trailingWidth: CGFloat
    let bottomWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Create the outer rounded rectangle
        let outerPath = Path(roundedRect: rect, cornerRadius: cornerRadius)
        
        // Calculate the maximum inset needed
        let maxInset = max(topWidth, leadingWidth, trailingWidth, bottomWidth)
        
        // Create the inner rounded rectangle
        let innerRect = CGRect(
            x: rect.minX + leadingWidth,
            y: rect.minY + topWidth,
            width: rect.width - leadingWidth - trailingWidth,
            height: rect.height - topWidth - bottomWidth
        )
        
        let innerCornerRadius = max(0, cornerRadius - maxInset)
        let innerPath = Path(roundedRect: innerRect, cornerRadius: innerCornerRadius)
        
        // Subtract inner from outer
        path.addPath(outerPath)
        path.addPath(innerPath)
        
        return path
    }
}
