//
//  SingleTransactionView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//

import SwiftUI

struct SingleTransactionView: View {
    
    struct FormRow: View {
        let label: String
        @Binding var text: String
        var body: some View {
            HStack {
                Text(label)
                    .frame(width: 100, alignment: .trailing)
                    .font(.listHeader)
                CustomTextFieldView(placeholder: "", text: $text)
            }
        }
    }
    
    @State var pickerSelected = 0
    @State var transaction : Transaction
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack {
                        HStack {
                            Text("Nouvelle entrée")
                                .font(.title)
                            Spacer()
                        }
                        FinancialPicker(options: ["Dépense", "Recette"], selected: $pickerSelected)
                    }
                    .padding(.horizontal)
                    VStack(spacing: 24) {
                        FormRow(label: "Montant", text: $transaction.contractor)
                        FormRow(label: "Nom", text: $transaction.contractor)
                        FormRow(label: "Catégorie", text: $transaction.contractor)
                        FormRow(label: "À", text: $transaction.contractor)
                        FormRow(label: "Date", text: $transaction.contractor)
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
    SingleTransactionView(transaction:
                        Transaction(name: "Assurance", amount: 1000.20, date: Date(), contractor: "AXA Assurance")
    )
}
