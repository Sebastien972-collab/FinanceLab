//
//  StandardCard.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 26/09/2025.
//

import SwiftUI

struct StandardCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack() {
            self.content
        }
        .multilineTextAlignment(.leading)
        .lineSpacing(1.6)
//        .foregroundStyle(Color.primary)
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(width: 370)
        .shadow(radius: 3)
    }
}

#Preview {
    StandardCard{
        Text("Aperçu du contenu de la cartecartcartcartca")
                    .padding()
        Text("Aperçu du contenu de la carte")
        Text("Aperçu du contenu de la carte")
        Text("Aperçu du contenu de la carte")
        Text("Aperçu du contenu de la carte")
            .padding()
    }
}
