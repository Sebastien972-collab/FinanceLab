//
//  ProgressCardView.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 05/02/2026.
//

import SwiftUI

struct ProgressCardView: View {
    var progressPercentage: Double
    var amountSaved: Decimal
    var goalAmount: Decimal
    var body: some View {
        VStack(spacing: 20) {
            // Jauge Circulaire
            ZStack {
                // Fond
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 15)
                    .frame(width: 180, height: 180)
                Circle()
                    .trim(from: 0, to: CGFloat(progressPercentage / 100))
                    .stroke(
                        LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: amountSaved)
                VStack(spacing: 4) {
                    Text("\(Int(progressPercentage))%")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Complété")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                }
            }
            .padding(.top, 10)

            // Montants
            HStack {
                VStack(alignment: .leading) {
                    Text("Actuel")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                    Text("\(amountSaved.formatted(.number.precision(.fractionLength(0)))) €")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Cible")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                    Text("\(goalAmount.formatted(.number.precision(.fractionLength(0)))) €")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    ProgressCardView(progressPercentage: 10, amountSaved: 100, goalAmount: 1000)
}
