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
    
    @State private var showTransactionSheet = false
    @State private var pickerSelected = 0

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
                    VStack(alignment: .leading) {
                        let groupedTransactions = Dictionary(grouping: accountVM.getLatestTransactions()) { transaction in
                            transaction.date.formatted(.dateTime
                                .day()
                                .month(.wide)
                                .year()
                                .locale(Locale(identifier: "fr_FR")))
                        }
                        ForEach(groupedTransactions.sorted(by: { $0.key > $1.key }), id: \.key) { (dateString, transactions) in
                            Text(dateString)
                                .font(.listHeader)
                                .padding(.top, 6)
                            ForEach(transactions) { transaction in
                                NavigationLink(destination: SingleTransactionView(transaction: transaction).environment(accountVM)) {
                                    TransactionListRow(name: transaction.name, icon: transaction.icon, amount: transaction.amount)
                                }
                            }
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
                        showTransactionSheet = true
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showTransactionSheet) {
                    SingleTransactionView().environment(accountVM)
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
