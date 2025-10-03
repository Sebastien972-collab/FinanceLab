//
//  TransactionsView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct TransactionsView: View {
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
                        case 0: SpendingRepartition(amountSpent: 846.12, amountGained: 1820.11)
                        default: Text("TODO")
                            // TODO: Budget par catégories
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
}

#Preview {
    TransactionsView()
}
