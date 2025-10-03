//
//  TransactionsView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct TransactionsView: View {
    @State var pickerSelected = 0
    private let testTransactions : [Transaction] = [
        Transaction(name: "Assurance", amount: 2100, date: Date(), contractor: "AXA Assurance")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(Date()
                            .formatted(.dateTime
                                .month(.wide)
                                .year()
                                .locale(Locale(identifier: "fr_FR")))
                                .capitalized)
                        .font(.title)
                        FinancialPicker(options: [
                            "Dépenses et recettes",
                            "Par catégories"
                        ], selected: $pickerSelected)
                    }
                    switch pickerSelected {
                        case 0: SpendingRepartition(amountSpent: 846.12, amountGained: 1820.11)
                        default: Text("TODO")
                            // TODO: Budget par catégories
                    }
                    VStack {
                        SingleTransactionRow()
                    }
                }
                .foregroundStyle(Color.Text.contrasted)
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        // dismiss
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Nouvelle transaction", image: .circlesThreePlusFill) {
                        // action
                    }
                }
            }
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
    
    struct SingleTransactionRow: View {
        var body: some View {
            HStack {
                HStack {
                    Image(.circlesThreePlusFill)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Assurance")
                }
                .padding(.horizontal, 10)
                .font(.cardSubtitle)
                Spacer()
                HStack(spacing: 2) {
                    Text("42")
                        .font(.listLargeNumber)
                    Text(",")
                    Text("24")
                    Text("€")
                }
                .frame(height: 42)
                .padding(.horizontal, 10)
                .background(LinearGradient.redGradient)
                .font(.listNumber)
            }
            .frame(height: 42)
            .foregroundStyle(Color.Text.primary)
            .background(Color.Card.background)
            .cornerRadius(50)
        }
    }
}

#Preview {
    TransactionsView()
}
