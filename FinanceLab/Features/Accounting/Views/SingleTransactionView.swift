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
        _editableTransaction = State(initialValue: transaction ?? Transaction(name: "", iconName: .selectionFill, amount: 0, date: Date(), contractor: ""))
    }
    
    var isFormValid: Bool {
        !editableTransaction.name.isEmpty && !editableTransaction.amount.isZero && !editableTransaction.contractor.isEmpty
    }
    @State private var isDatePickerPresented = false
    @State private var showCancelAlert = false
    @State private var showDeleteAlert = false
    
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
                        HStack {
                            Spacer()
                            Text(editableTransaction.date.formatted(date: .numeric, time: .omitted))
                        }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .frame(height: 42)
                            .frame(maxWidth: 260)
                            .background(Color.Segmented.background)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .onTapGesture {
                                isDatePickerPresented = true
                            }
                    }
                }
                .font(.inputFieldLabel)
                .padding()
                .foregroundStyle(Color.Text.contrasted)
            }
            .alert("Attention !", isPresented: $showCancelAlert) {
                Button("Abandonner les changements", role: .destructive) {
                    dismiss()
                }
                Button("Continuer à éditer", role: .cancel) {}
            } message: {
                Text("Vous n'avez pas encore sauvegardé les changements en cours. Êtes-vous sûr·e de vouloir abandonner ?")
            }
            .alert("Attention !", isPresented: $showDeleteAlert) {
                Button("Supprimer l'entrée", role: .destructive) {
                    Task {
                        await accountVM.deleteTransaction(initialTransaction!.id)
                    }
                    dismiss()
                }
                Button("Continuer à éditer", role: .cancel) {}
            } message: {
                Text("Voulez-vous vraiment supprimer cette entrée ? Cette opération est irréversible.")
            }
            .sheet(isPresented: $isDatePickerPresented) {
                DatePicker("Date", selection: $editableTransaction.date, in: ...Date(), displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                .foregroundStyle(Color.Text.contrasted)
                .presentationBackground {
                    Rectangle()
                        .foregroundStyle(Color.App.background)
                }
                .presentationDragIndicator(.hidden)
                .presentationDetents([.fraction(0.3)])
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        showCancelAlert = true
                    }
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
                if initialTransaction != nil {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Supprimer", image: .trashFill) {
                            showDeleteAlert = true
                        }
                        .buttonStyle(FinanceButton(state: .cancel, size: .round))
                    }
                    .sharedBackgroundVisibility(.hidden)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            if initialTransaction != nil {
                                await accountVM.putTransaction(editableTransaction)
                            } else {
                                await accountVM.postTransaction(editableTransaction)
                            }
                            dismiss()
                        }
                    }
                    .buttonStyle(FinanceButton(state: .validate, size: .mini))
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1 : 0.5)
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
    SingleTransactionView()
        .environment(AccountViewModel())
}

