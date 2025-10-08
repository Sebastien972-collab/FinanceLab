//
//  RASView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

struct RASView: View {
    var monthlyRAS: Double = 150.02
    var dailyRAS: Double = 5.55
    
    var body: some View {
        VStack {
            Text("Reste à s'amuser")
                .font(.cardSubtitle)
                .foregroundStyle(Color.Text.secondary)
            HStack {
                HStack(spacing: 4) {
                    Text(monthlyRAS.description)
                        .font(.cardNumber)
                    Text("€")
                        .font(.cardCurrency)
                }
                Spacer()
                HStack(spacing: 4) {
                    Text("~")
                        .font(.cardCurrency)
                    Text(dailyRAS.description)
                        .font(.cardNumber)
                    Text("€")
                        .font(.cardCurrency)
                }
            }
        }
        .foregroundStyle(Color.Text.primary)
    }
}

#Preview {
    RASView()
        .padding()
        .background {
            ZStack {
                FinancialBackground().ignoresSafeArea()
                Rectangle()
                    .fill(Color.Card.background)
            }
        }
}
