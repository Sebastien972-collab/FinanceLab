//
//  TransactionsView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct TransactionListView: View {
    @Environment(\.dismiss) private var dismiss
    @State var accountVM = AccountViewModel()
    
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
                        ForEach(accountVM.getLatestTransactions()) { transaction in
                            TransactionListRow(name: transaction.name, icon: transaction.icon, amount: transaction.amount)
                        }
                    }
                }
                .foregroundStyle(Color.Text.contrasted)
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        dismiss()
                    }
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .primaryAction) {
                    Button("Nouvelle transaction", image: .circlesThreePlusFill) {
                        accountVM.setNewTransaction()
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .navigationBarBackButtonHidden()
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    TransactionListView()
}
