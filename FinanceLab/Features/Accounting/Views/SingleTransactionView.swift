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
    
    @State private var editableTransaction: Transaction
    let initialTransaction: Transaction?
    
    init(transaction: Transaction? = nil) {
        self.initialTransaction = transaction
        _editableTransaction = State(initialValue: transaction ?? Transaction(name: "", icon: .selectionFill, amount: 0, date: Date(), contractor: ""))
    }
    
    @State private var showCancelAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    HStack {
                        Text(initialTransaction != nil ? "Éditer une entrée" : "Nouvelle entrée")
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Text("Nom")
                        Spacer()
                        TextField("Nom", text: $editableTransaction.name)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Montant")
                        Spacer()
                        TextField("Montant", value: $editableTransaction.amount, format: .currency(code: "EUR"))
                            .textFieldStyle(CustomTextFieldStyle(fontSize: .big))
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Contractant")
                        Spacer()
                        TextField("Contractant", text: $editableTransaction.contractor)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Date")
                        Spacer()
                        DatePicker("Date", selection: $editableTransaction.date, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: 260, maxHeight: 330)
                    }
                }
                .font(.inputFieldLabel)
                .padding()
                .foregroundStyle(Color.Text.contrasted)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        showCancelAlert = true
                        dismiss()
                    }
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .primaryAction) {
                    Button("Enregistrer") {
                        accountVM.saveTransaction(editableTransaction)
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
    SingleTransactionView()
        .environment(AccountViewModel())
}
