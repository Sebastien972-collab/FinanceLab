//
//  QuestionCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 09/10/2025.
//

import SwiftUI

struct QuestionCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .cornerRadius(100)
                    .foregroundStyle(Color.App.background.opacity(0.30))
                VariableStrokeRoundedRectangle(
                    cornerRadius: 100,
                    topWidth: 10,
                    leadingWidth: 5,
                    trailingWidth: 0,
                    bottomWidth: 0
                )
                .fill(LinearGradient.greenGradient, style: FillStyle(eoFill: true))
                .hideQuarter(.bottomTrailing)
                VStack(alignment: .center, spacing: 16) {
                        self.content
                    }
                .multilineTextAlignment(.center)
                .padding(42)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image(.mascot)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                    }
                }
            }
            Spacer()
        }
        .frame(height: 460)
        .font(.body)
        .foregroundStyle(Color.Text.contrasted)
        .multilineTextAlignment(.leading)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    QuestionCard {
        Text("Contenu de la carte")
    }
    .padding()
    .background {
        FinancialBackground().ignoresSafeArea()
    }
}
