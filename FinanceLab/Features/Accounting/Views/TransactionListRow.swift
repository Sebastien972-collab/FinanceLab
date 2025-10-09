//
//  SingleTransactionRow.swift
//  FinanceLab
//
//  Created by Anne Ferret on 03/10/2025.
//

import SwiftUI

struct TransactionListRow: View {
    var name: String
    var icon: ImageResource
    var amount: Double

    var body: some View {
        HStack {
            HStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                    .foregroundStyle(LinearGradient.primaryGradient)
                Text(name)
            }
            .padding(.horizontal, 10)
            .font(.cardSubtitle)
            Spacer()
            HStack(spacing: 2) {
                Spacer()
                Text(amount.description.split(separator: ".")[0])
                    .font(.listLargeNumber)
                Text(",")
                Text(amount.description.split(separator: ".")[1])
                Text("€")
            }
            .frame(width: 100, height: 42)
            .padding(.horizontal, 10)
            .background(amount > 0 ? LinearGradient.greenGradient : LinearGradient.redGradient)
            .font(.listNumber)
        }
        .frame(height: 42)
        .foregroundStyle(Color.Text.primary)
        .background(Color.Card.background)
        .cornerRadius(50)
    }
}

#Preview {
    VStack {
        TransactionListRow(name: "Assurance", icon: .circlesThreePlusFill, amount: -42.24)
        TransactionListRow(name: "Salaire", icon: .circlesThreePlusFill, amount: 2000.24)
    }
        .padding()
        .background {
            FinancialBackground().ignoresSafeArea()
        }
}
