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
        HStack{
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
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    StandardCard{
        Text("Aperçu du contenu de la cartecartcartcartca")
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
