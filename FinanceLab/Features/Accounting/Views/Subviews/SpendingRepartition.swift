//
//  SpendingRepartition.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct SpendingRepartition: View {
    var amountSpent: Double
    var amountGained: Double
    
    var body: some View {
        VStack(spacing: 20) {
            PercentageSlider(percentage: (amountSpent / (amountGained + amountSpent)), height: .big, color: .redToGreen)
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Text("-")
                        Text(amountSpent.description.split(separator: ".")[0])
                            .font(.listLargeNumber)
                        Text(",")
                        Text(amountSpent.description.split(separator: ".")[1])
                        Text("€")
                    }
                    .font(.listNumber)
                    Text("Dépenses")
                        .font(.cardCallout)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: 2) {
                        Text("+")
                        Text(amountGained.description.split(separator: ".")[0])
                            .font(.listLargeNumber)
                        Text(",")
                        Text(amountGained.description.split(separator: ".")[1])
                        Text("€")
                    }
                    .font(.listNumber)
                    Text("Recettes")
                        .font(.cardCallout)
                }
            }
        }
        .foregroundStyle(Color.Text.contrasted)
    }
}

#Preview {
    SpendingRepartition(amountSpent: 1367.12, amountGained: 2000)
        .padding()
        .background {
            FinancialBackground().ignoresSafeArea()
        }
}
