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
                        .font(.cardTitle)
                    Text(subtitle)
                        .font(.cardSubtitle)
                        .foregroundStyle(Color.Text.secondary)
                }
                Spacer()
                Text(info)
                    .font(.cardCurrency)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
            }
            .padding()
        }
        .foregroundStyle(Color.Text.primary)
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
