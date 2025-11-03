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
    var body: some View {
        StandardCard {
            HStack(spacing: 16) {
                if let image = CategoryIcon(rawValue: project.iconName ?? CategoryIcon.houseLineFill.rawValue) {
                    image.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(LinearGradient.primaryGradient)
                        .frame(maxWidth: 56, maxHeight: 56)
                } else {
                    ImageCard(imageName: "target")
                }
                VStack(alignment: .leading) {
                    Text(project.name)
                        .font(.cardTitle)
                        .lineLimit(1)
                    HStack {
                        Text(project.amountSaved.formatted(.number.precision(.fractionLength(2))))
                            .font(.cardCurrency)
                            .lineLimit(1)
                        Text(project.currency.symbol)
                            .font(.cardCurrency)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: -4) {
                    Text("terminé à")
                        .font(.cardCallout)
                        .foregroundStyle(Color.Text.secondary)
                    HStack {
                        Text("\(Int(project.progressPercentage))")
                            .font(.cardNumber)
                        Text("%")
                            .font(.cardCurrency)
                    }
                }
            }
            .foregroundStyle(Color.Text.primary)
            .padding()
            .clipped()
            
        }
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
