//
//  ProjectDetailsCard.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 06/10/2025.
//

import SwiftUI
import FinanceCore

struct ProjectDetailsCardView: View {
    let title: String
    let subtitle: String
    let info: String    
    var body: some View {
        StandardCard {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(Font.custom("Host Grotesk", size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.Text.primary)
                    Text(subtitle)
                        .font(Font.custom("Host Grotesk", size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.Text.primary)
                    
                }
                Spacer()
                Text(info)
                    .font(Font.custom("Host Grotesk", size: 32))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Text.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
            }
            .padding()
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ProjectDetailsCardView(title: "Épargne mensuelle", subtitle: "Je mets de côté chaque mois", info: "100 €")
        ProjectDetailsCardView(title: "Fin", subtitle: "À ce rythme, ce projet sera fini en", info: Project.preview.deadlineFormatted)
        Spacer()
    }
    .padding()
    .background {
        FinancialBackground()
            .ignoresSafeArea()
    }
}
