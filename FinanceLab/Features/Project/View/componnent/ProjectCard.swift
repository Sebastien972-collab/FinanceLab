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
            HStack {
                if let imageName = project.currentImage {
                    ImageCard(imageName: imageName)
                } else {
                    ImageCard(imageName: "target")
                }
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(Font.cardTitle)
                            .foregroundStyle(Color.Text.primary)
                        Text(project.formattedAmount)
                            .font(Font.cardNumber)
                            .foregroundStyle(Color.Text.primary)
                    }
                    Spacer()
                    VStack {
                        Text("terminé à")
                            .font(Font.cardCallout)
                            .foregroundStyle(Color.Text.primary)
                        Text("\(Int(project.progressPercentage)) %")
                            .font(Font.cardNumber)
                            .foregroundStyle(Color.Text.primary)
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    ZStack {
        FinancialBackground()
            .ignoresSafeArea()
        ProjectCard(project: .preview)
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
            .padding()
    }
}
