//
//  SingleTransactionView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct SingleTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountViewModel.self) var accountVM

    @State var pickerSelected = 0
    @State var transaction : Transaction
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    TextField("Nom", text: $transaction.name)
                    TextField("Montant", value: $transaction.amount, format: .number)
                    TextField("Contractant", text: $transaction.contractor)
                    DatePicker("Date", selection: $transaction.date)
                    
                    HStack {
                        Button("Annuler") {
                            accountVM.cancelEditing()
                        }
                        Button("Sauvegarder") {
                            accountVM.saveTransaction(transaction)
                        }
                    }
                }
//                VStack(spacing: 24) {
//                    VStack(alignment: .leading) {
//                        Text("Nouvelle entrée")
//                            .font(.title)
//                        FinancialPicker(options: ["Dépense", "Recette"], selected: $pickerSelected)
//                    }
//                    .padding(.horizontal)
//                    VStack(spacing: 24) {
//                        FormRow(label: "Montant", text: $transaction.contractor)
//                        FormRow(label: "Nom", text: $transaction.name)
//                        FormRow(label: "Catégorie", text: $transaction.name)
//                        FormRow(label: "À", text: $transaction.name)
//                        FormRow(label: "Date", text: $transaction.name)
//                    }
//                }
                .foregroundStyle(Color.Text.contrasted)
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
                    Button("Enregistrer") {
                        accountVM.saveTransaction(transaction)
                    }
                    .buttonStyle(FinanceButton(state: .validate, size: .mini))
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .navigationBarBackButtonHidden()
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
    
    struct FormRow: View {
        let label: String
        @Binding var text: String
        var body: some View {
            HStack(spacing: 18) {
                Text(label)
                    .frame(width: 100, alignment: .trailing)
                    .font(.listHeader)
                CustomTextFieldView(placeholder: "", text: $text)
            }
        }
    }
}

#Preview {
    SingleTransactionView(transaction:
                            Transaction(name: "Assurance", icon:.lifebuoyFill, amount: 1000.20, date: Date(), contractor: "AXA Assurance")
    ).environment(AccountViewModel())
}
