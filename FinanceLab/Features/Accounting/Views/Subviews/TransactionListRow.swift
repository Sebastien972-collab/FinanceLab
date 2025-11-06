//
//  SingleTransactionRow.swift
//  FinanceLab
//
//  Created by Anne Ferret on 03/10/2025.
//

import SwiftUI

struct TransactionListRow: View {
    var name: String
    var icon: CategoryIcon
    var amount: Double

    var body: some View {
        HStack {
            HStack {
                Image(icon.resource)
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
                let parts = String(format: "%.2f", amount).split(separator: ".")
                Spacer()
                Text(String(parts[0]))
                    .font(.listLargeNumber)
                Text(",")
                Text(String(parts[1]))
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
        TransactionListRow(name: "Assurance", icon: .lifebuoyFill, amount: -42.24)
        TransactionListRow(name: "Salaire", icon: .currencyEurFill, amount: 2000.24)
    }
        .padding()
        .background {
            FinancialBackground().ignoresSafeArea()
        }
}
