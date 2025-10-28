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
    
    @State private var pickerSelected = 0
    @State private var isLoading = false

    var body: some View {
    NavigationStack {
    ScrollView {
        if isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 24) {
                Text(Date()
                    .formatted(.dateTime
                        .month(.wide)
                        .year()
                        .locale(Locale(identifier: "fr_FR")))
                        .capitalized)
                    .font(.title)
                if accountVM.transactionsList.isEmpty {
                    NavigationLink(destination: SingleTransactionView().environment(accountVM)) {
                        DemboCard {
                            Text("Tu n'as pas encore commencé à gérer tes transactions avec Serenly. Enregistre une première transaction dès maintenant !")
                        }
                    }
                } else {
                    FinancialPicker(options: [
                        "Dépenses et recettes",
                        "Par catégories"
                    ], selected: $pickerSelected)
                }
                switch pickerSelected {
                    case 0: if accountVM.spent != 0 || accountVM.gained != 0 {
                        SpendingRepartition(
                            spent: $accountVM.spent,
                            gained: $accountVM.gained
                        )
                    }
                    default: Text("TODO")
                        // TODO: Budget par catégories
                }
                VStack(alignment: .leading) {
                    let groupedTransactions = Dictionary(grouping: accountVM.transactionsList) { transaction in
                        Calendar.current.startOfDay(for: transaction.date)
                    }
                    ForEach(groupedTransactions.sorted(by: { $0.key > $1.key }), id: \.key) { (date, transactions) in
                        Text(date.formatted(.dateTime
                            .day()
                            .month(.wide)
                            .year()
                            .locale(Locale(identifier: "fr_FR"))))
                        .font(.listHeader)
                        .padding(.top, 6)
                        ForEach(transactions) { transaction in
                            NavigationLink(destination: SingleTransactionView(transaction: transaction).environment(accountVM)) {
                                TransactionListRow(name: transaction.name, icon: transaction.iconName, amount: transaction.amount)
                            }
                        }
                }
            }
            }
            .foregroundStyle(Color.Text.contrasted)
            .padding()
        }
    }
            .task {
                isLoading = true
                try! await Task.sleep(for: .milliseconds(10))
                await accountVM.fetchTransactions()
                accountVM.calcSpendingRepartition()
                isLoading = false
            }
//            .refreshable {
//                isLoading = true
//                await accountVM.fetchTransactions()
//                accountVM.calcSpendingRepartition()
//                isLoading = false
//            }
            .alert("Error", isPresented: $accountVM.showError) {
                Button {} label: {
                    Text("Ok")
                }
            } message: {
                Text(accountVM.error.localizedDescription)
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
                    NavigationLink {
                        SingleTransactionView().environment(accountVM)
                    } label: {
                        Label("Nouvelle transaction", image: .circlesThreePlusFill)
                            .labelStyle(.iconOnly)
                    }
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
