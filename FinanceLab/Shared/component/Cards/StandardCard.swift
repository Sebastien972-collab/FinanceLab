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
<<<<<<< HEAD:FinanceLab/Shared/component/Cards/StandardCard.swift
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .font(.body)
        .foregroundStyle(Color.Text.primary)
        .multilineTextAlignment(.leading)
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 30))
=======
            .multilineTextAlignment(.leading)
            .lineSpacing(1.6)
            .background(Color.Card.background.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .frame(maxWidth: .infinity)
            .shadow(radius: 3)
>>>>>>> 7cb17cc7bbc8975d41ad84cce323d86cd2435d4a:FinanceLab/Shared/component/StandardCard.swift
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
    .background {
        FinancialBackground()
            .ignoresSafeArea(.all)
    }
}
