//
//  DemboCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

struct DemboCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            ZStack {
                VariableStrokeRoundedRectangle(
                    cornerRadius: 100,
                    topWidth: 0,
                    leadingWidth: 5,
                    trailingWidth: 0,
                    bottomWidth: 10
                )
                .fill(LinearGradient.greenGradient, style: FillStyle(eoFill: true))
                .hideQuarter(.topTrailing)
                HStack(spacing: 24) {
                    VStack {
                        self.content
                    }
                    .frame(height: 110)
                    .clipped()
                    Image(.mascot)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
            }
            Spacer()
        }
        .frame(height: 150)
        .font(.demboAdvice)
        .foregroundStyle(Color.Text.contrasted)
        .multilineTextAlignment(.leading)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    DemboCard{
        Text("Aperçu du contenu de la carte")
    }
    .padding()
    .background {
        FinancialBackground().ignoresSafeArea()
    }
}
