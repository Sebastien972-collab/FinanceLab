//
//  ProjectCard.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//

import SwiftUI
import FinanceCore

struct ProjectCard: View {
    let project: Project
    
    var progress: Double {
        project.progressPercentage / 100.0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // 1. Icône dans une bulle
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.white.opacity(0.1), .white.opacity(0.05)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
                
                if let iconName = project.iconName, let icon = CategoryIcon(rawValue: iconName) {
                    Image(icon.resource)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "target")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
            
            // 2. Infos Principales
            VStack(alignment: .leading, spacing: 6) {
                Text(project.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(project.amountSaved.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Text("/ \(project.goalAmount.formatted(.number.notation(.compactName))) \(project.currency.symbol)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // 3. Indicateur de Progression Circulaire
            ZStack {
                // Fond du cercle
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 5)
                    .frame(width: 50, height: 50)
                
                // Progression
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(
                        LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                // Pourcentage texte au centre
                Text("\(Int(project.progressPercentage))%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(LinearGradient(colors: [.white.opacity(0.4), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ProjectCard(project: .preview)
        .background {
            FinancialBackground()
                .ignoresSafeArea(.all)
        }
}

private struct ImageCard: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(LinearGradient.primaryGradient)
            .frame(maxWidth: 56, maxHeight: 56)
    }
}
