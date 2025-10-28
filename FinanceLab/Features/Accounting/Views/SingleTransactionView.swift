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
        _pickerSelected = State(initialValue: (transaction?.amount ?? 0) > 0 ? 1 : 0)
    }
    
    private var isFormValid: Bool {
        !editableTransaction.name.isEmpty && !editableTransaction.amount.isZero && !editableTransaction.contractor.isEmpty
    }
    
    @FocusState private var isAmountFieldFocused: Bool
    @State private var isDatePickerPresented = false
    @State private var isCategoryPickerPresented = false
    @State private var showCancelAlert = false
    @State private var showDeleteAlert = false
    @State private var pickerSelected: Int

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                        Text(initialTransaction != nil ? "Éditer une entrée" : "Nouvelle entrée")
                            .font(.title)
                        FinancialPicker(options: ["Dépense", "Recette"], selected: $pickerSelected)
                    HStack(spacing: 42) {
                        VStack(alignment: .leading) {
                            Text("Icône")
                            HStack {
                                Image(editableTransaction.iconName.resource)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .padding(4)
                            .frame(width: 72, height: 42)
                            .background(Color.Segmented.background)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .onTapGesture {
                                isCategoryPickerPresented = true
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Montant")
                            HStack {
                                TextField("Montant", value: Binding(
                                    get: { abs(editableTransaction.amount) },
                                    set: { editableTransaction.amount = abs($0) }
                                ), format: .number.precision(.fractionLength(2)))
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(CustomTextFieldStyle(fontSize: .big))
                                    .focused($isAmountFieldFocused)
                                    .onChange(of: isAmountFieldFocused) { _, isFocused in
                                        if isFocused {
                                            DispatchQueue.main.async {
                                                UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                                            }
                                        }
                                    }

                                Text("€")
                                    .font(.inputFieldNumber)
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Nom")
                        TextField("Nom", text: $editableTransaction.name)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    VStack(alignment: .leading) {
                        Text("Contractant")
                        TextField("Contractant", text: $editableTransaction.contractor)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    VStack(alignment: .leading) {
                        Text("Date")
                        HStack {
                            Spacer()
                            Text(editableTransaction.date.formatted(date: .numeric, time: .omitted))
                        }
                            .font(.inputFieldNumber)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .frame(height: 42)
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
                VStack {
                    DatePicker("Date", selection: $editableTransaction.date, in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .foregroundStyle(Color.Text.contrasted)
                        .presentationBackground {
                            Rectangle()
                                .foregroundStyle(Color.App.background)
                        }
                }
                .foregroundStyle(Color.Text.contrasted)
                .presentationDragIndicator(.hidden)
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(isPresented: $isCategoryPickerPresented) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                        ForEach(CategoryIcon.allCases) { icon in
                            Image(icon.resource)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(6)
                                .background(icon == editableTransaction.iconName ? LinearGradient.greenGradient : LinearGradient.clearGradient)
                                .foregroundStyle(icon == editableTransaction.iconName ? Color.Text.primary : Color.Text.contrasted)
                                .cornerRadius(24)
                                .onTapGesture {
                                    editableTransaction.iconName = icon
                                    isCategoryPickerPresented = false
                                }
                        }
                    }
                    .padding()
                }
                .foregroundStyle(Color.Text.contrasted)
                .presentationDragIndicator(.hidden)
                .presentationDetents([.medium, .large])
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
                        if pickerSelected == 0 {
                            editableTransaction.amount = -abs(editableTransaction.amount)
                        } else {
                            editableTransaction.amount = abs(editableTransaction.amount)
                        }
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
                    .opacity(isFormValid ? 1 : 0.25)
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

