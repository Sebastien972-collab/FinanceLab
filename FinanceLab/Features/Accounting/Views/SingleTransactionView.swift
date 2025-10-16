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
    var isNew : Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    HStack {
                        Text(isNew ? "Nouvelle entrée" : "Éditer une entrée")
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Text("Nom")
                        Spacer()
                        TextField("Nom", text: $transaction.name)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Montant")
                        Spacer()
                        TextField("Montant", value: $transaction.amount, format: .currency(code: "EUR"))
                            .textFieldStyle(CustomTextFieldStyle(fontSize: .big))
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Contractant")
                        Spacer()
                        TextField("Contractant", text: $transaction.contractor)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Date")
                        Spacer()
                        DatePicker("Date", selection: $transaction.date, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: 260, maxHeight: 330)
                    }
                }
                .font(.inputFieldLabel)
                .padding()
                .foregroundStyle(Color.Text.contrasted)

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
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        accountVM.cancelEditing()
                        dismiss()
                    }
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .primaryAction) {
                    Button("Enregistrer") {
                        accountVM.saveTransaction(transaction)
                        dismiss()
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
