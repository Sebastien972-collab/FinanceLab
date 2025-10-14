//
//  InfoPickCard.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct InfoPickCard: View {
    var label: String
    var icon: ImageResource
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    .foregroundStyle(LinearGradient.primaryGradient)
                Text(label)
                    .font(.cardTitle)
                    .foregroundStyle(Color.Text.primary)
            }
            Spacer()
        }
        .frame(height: 100)
        .multilineTextAlignment(.leading)
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    InfoPickCard(label: "Articles", icon: .newspaperClippingFill)
}
