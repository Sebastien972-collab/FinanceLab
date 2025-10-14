//
//  OnboardingCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 09/10/2025.
//

import SwiftUI

struct OnboardingCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        QuestionCard {
            self.content
        }
    }
}

#Preview {
    OnboardingCard {
        Text("Aperçu du contenu de la carte")
    }
    .padding()
    .background {
        FinancialBackground().ignoresSafeArea()
    }
}
