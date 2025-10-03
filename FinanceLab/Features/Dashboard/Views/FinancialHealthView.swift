//
//  FinancialHealthView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct FinancialHealthView : View {
    @State var healthScore : Double
    
    var body: some View {
        VStack {
            Text("Indice de santé financière")
                .font(.cardSubtitle)
            HStack {
                Image(.smileySadFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(LinearGradient.primaryGradient)
                    .offset(y:-5)
                GeometryReader { geo in
                    VStack {
                        HStack(spacing:0) {
                            Rectangle()
                                .fill(LinearGradient.greenGradient)
                                .frame(width: geo.size.width * healthScore)
                            Rectangle()
                                .fill(LinearGradient.primaryGradient)
                        }
                        .frame(height: 10)
                        .cornerRadius(50)
                        HStack(spacing:0) {
                            Spacer()
                                .frame(width: geo.size.width * healthScore - 5)
                            Image(.polygonFill)
                                .foregroundStyle(LinearGradient.redGradient)
                            Spacer()
                        }
                    }
                }
                Image(.smileyFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(LinearGradient.primaryGradient)
                    .offset(y:-5)
            }
            .frame(height:20)
        }
        .foregroundStyle(Color.Text.primary)
        .onAppear {
            // Prevents weird spacing issues
            if healthScore < 0.05 {
                healthScore = 0.05
            } else if healthScore > 0.95 {
                healthScore = 0.95
            }
        }
    }
}

#Preview {
    FinancialHealthView(healthScore: 0.8)
        .padding()
        .background {
            ZStack {
                FinancialBackground().ignoresSafeArea()
                Rectangle()
                    .fill(Color.Card.background)
            }
        }
}
