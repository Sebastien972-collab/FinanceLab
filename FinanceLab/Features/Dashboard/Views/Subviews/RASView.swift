//
//  RASView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

struct RASView: View {
    var monthlyRAS: Decimal
    var dailyRAS: Decimal
    var endOfMonth: String = "30 septembre" // TODO: replace with dynamic end of month
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Reste à s'amuser")
                .font(.cardSubtitle)
                .foregroundStyle(Color.Text.secondary)
            HStack {
                VStack {
                    HStack(spacing: 4) {
                        Spacer()
                        Text(monthlyRAS.description.split(separator: ".")[0])
                            .font(.cardNumber)
                        Text("€")
                            .font(.cardCurrency)
                        Spacer()
                    }
                    Text("jusqu'au " + endOfMonth)
                        .font(.cardCallout)
                        .foregroundStyle(Color.Text.secondary)
                }
                Spacer()
                Rectangle()
                    .foregroundStyle(Color.Text.secondary)
                    .frame(width: 2, height: 33)
                Spacer()
                VStack {
                    HStack(spacing: 4) {
                        Spacer()
                        Text("~")
                            .font(.cardCurrency)
                        Text(dailyRAS.description)
                            .font(.cardNumber)
                        Text("€")
                            .font(.cardCurrency)
                        Spacer()
                    }
                    Text("par jour")
                        .font(.cardCallout)
                        .foregroundStyle(Color.Text.secondary)
                }
            }
        }
        .foregroundStyle(Color.Text.primary)
    }
}

#Preview {
    RASView(monthlyRAS: 150.24, dailyRAS: 5.55)
        .padding()
        .background {
            ZStack {
                FinancialBackground().ignoresSafeArea()
                Rectangle()
                    .fill(Color.Card.background)
            }
        }
}
