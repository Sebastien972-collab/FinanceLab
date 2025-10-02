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
            .background(Color.Card.background.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .frame(maxWidth: .infinity)
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
    .background {
        FinancialBackground()
            .ignoresSafeArea(.all)
    }
}
