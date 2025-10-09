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
        VStack {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient.redGradient)
                    Rectangle()
                        .fill(LinearGradient.greenGradient)
                        .frame(width: geo.size.width * amountGained / (amountGained + amountSpent))
                }
            }
            .frame(height: 24)
            .cornerRadius(50)
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
    SpendingRepartition(amountSpent: 1367.12, amountGained: 1411.87)
        .padding()
        .background {
            FinancialBackground().ignoresSafeArea()
        }
}
