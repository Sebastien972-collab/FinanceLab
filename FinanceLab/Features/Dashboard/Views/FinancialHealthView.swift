//
//  FinancialHealthView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct FinancialHealthView : View {
    @State var healthScore : Double = 0.5
    
    var body: some View {
        VStack {
            Text("Indice de santé financière")
                .font(.cardSubtitle)
            HStack {
                Image(.smileyFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(LinearGradient.primaryGradient)
                    .offset(y:-5)
                GeometryReader { geo in
                    VStack {
                        HStack(spacing:0) {
                            Rectangle()
                                .fill(LinearGradient.primaryGradient)
                            Rectangle()
                                .fill(LinearGradient.greenGradient)
                                .frame(width: geo.size.width * healthScore)
                        }
                        .frame(height: 10)
                        .cornerRadius(50)
                        HStack(spacing:0) {
                            Spacer()
                            Image(.polygonFill)
                                .foregroundStyle(LinearGradient.redGradient)
                            Spacer()
                                .frame(width: geo.size.width * healthScore - 5)
                        }
                    }
                }
                Image(.smileySadFill)
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
    FinancialHealthView()
        .padding()
        .background {
            ZStack {
                FinancialBackground().ignoresSafeArea()
                Rectangle()
                    .fill(Color.Card.background)
            }
        }
}
