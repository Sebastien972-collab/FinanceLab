//
//  TransactionsView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct TransactionListView: View {
    @State var pickerSelected = 0

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
                        case 0: SpendingRepartition(amountSpent: 720.12, amountGained: 52.24)
                        default: Text("TODO")
                            // TODO: Budget par catégories
                    }
                    VStack {
                        TransactionListRow(name: "Assurance", icon: .circlesThreePlusFill, amount: -42.24)
                        TransactionListRow(name: "Salaire", icon: .circlesThreePlusFill, amount: 1298.64)
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
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .primaryAction) {
                    Button("Nouvelle transaction", image: .circlesThreePlusFill) {
                        // action
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    TransactionListView()
}
