//
//  DemboCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

struct DemboCard<Content: View>: View {
    let content: Content
    
    struct VariableStrokeRoundedRectangle: Shape {
        let cornerRadius: CGFloat
        let topWidth: CGFloat
        let leadingWidth: CGFloat
        let trailingWidth: CGFloat
        let bottomWidth: CGFloat
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            // Create the outer rounded rectangle
            let outerRect = rect
            let outerPath = Path(roundedRect: outerRect, cornerRadius: cornerRadius)
            
            // Create the inner rounded rectangle (inset by stroke widths)
            let innerRect = CGRect(
                x: rect.minX + leadingWidth,
                y: rect.minY + topWidth,
                width: rect.width - leadingWidth - trailingWidth,
                height: rect.height - topWidth - bottomWidth
            )
            
            // Calculate inner corner radius (needs to be adjusted for insets)
            let innerCornerRadius = max(0, cornerRadius - max(topWidth, leadingWidth, trailingWidth, bottomWidth))
            let innerPath = Path(roundedRect: innerRect, cornerRadius: innerCornerRadius)
            
            // Subtract inner from outer to create the stroke
            path.addPath(outerPath)
            path.addPath(innerPath)
            
            return path
        }
    }

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
     }
    
    var body: some View {
//        VariableStrokeRoundedRectangle (cornerRadius: <#T##CGFloat#>, topWidth: <#T##CGFloat#>, leadingWidth: <#T##CGFloat#>, trailingWidth: <#T##CGFloat#>, bottomWidth: <#T##CGFloat#>) {
            VStack(alignment: .leading, spacing: 16) {
                self.content
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .font(.body)
        .foregroundStyle(Color.Text.primary)
        .multilineTextAlignment(.leading)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    DemboCard {
        Text("Aperçu du contenu de la cartecartcartcartcartecarte")
        Text("Aperçu du contenu de la carte")
        Text("Aperçu du contenu de la carte")
        Text("Aperçu du contenu de la carte")
        Text("Aperçu du contenu de la carte")
    }
    .padding()
    .background {
        FinancialBackground().ignoresSafeArea()
    }
}
