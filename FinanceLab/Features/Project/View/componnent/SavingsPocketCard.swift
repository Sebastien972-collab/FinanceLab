//
//  SavingsPocketCard.swift
//  FinanceLab
//
//  Created by Codex on 20/03/2026.
//

import SwiftUI

struct SavingsPocketCard: View {
    let pocket: SavingsPocket

    private var progress: Double {
        pocket.progress
    }

    private var gradientColors: [Color] {
        switch pocket.kind {
        case .precautionary:
            return [.green, .cyan]
        case .provision:
            return [.blue, .cyan]
        case .longTerm:
            return [.orange, .yellow]
        case .project:
            return [.pink, .purple]
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradientColors.map { $0.opacity(0.22) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(.white.opacity(0.18), lineWidth: 1))

                Image(pocket.icon.resource)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(pocket.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(pocket.subtitle)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.66))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(pocket.currentAmount.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.95))

                    Text("/ \(pocket.targetAmount.formatted(.number.precision(.fractionLength(0)))) € \(pocket.targetLabel)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Text(pocket.detail)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.75))
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 5)
                    .frame(width: 54, height: 54)

                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(
                        LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: 54, height: 54)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.35), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    SavingsPocketCard(
        pocket: SavingsPocket(
            kind: .precautionary,
            title: "Épargne de précaution",
            subtitle: "3 mois de dépenses pour absorber les imprévus",
            icon: .bankFill,
            currentAmount: 900,
            targetAmount: 2400,
            detail: "Versement conseillé : 140 € / mois",
            targetLabel: "objectif"
        )
    )
    .padding()
    .background {
        FinancialBackground()
            .ignoresSafeArea()
    }
}
