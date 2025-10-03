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
            self.content.padding()
        }
        .multilineTextAlignment(.leading)
        .lineSpacing(1.6)
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack{
        FinancialBackground()
        HStack{
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
    }
}
