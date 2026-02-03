//
//  LiquidSingleTransactionView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//  Redesigned by Sébastien DAGUIN Développeur IOS 2026
//

import SwiftUI

struct SingleTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountViewModel.self) var accountVM
    
    @State private var editableTransaction: Transaction
    let initialTransaction: Transaction?
    
    // State UI
    @State private var pickerSelected: Int
    @FocusState private var isAmountFocused: Bool
    @State private var showCategorySheet = false
    @State private var showDatePicker = false
    @State private var showDeleteAlert = false
    
    init(transaction: Transaction? = nil) {
        self.initialTransaction = transaction
        _editableTransaction = State(initialValue: transaction ?? Transaction(name: "", iconName: .shoppingCartSimpleFill, amount: 0, date: Date(), contractor: ""))
        // Détection automatique Dépense/Recette selon le signe
        _pickerSelected = State(initialValue: (transaction?.amount ?? 0) > 0 ? 1 : 0)
    }
    
    private var isFormValid: Bool {
        !editableTransaction.name.isEmpty && editableTransaction.amount != 0
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Liquide
                LiquidMeshBackground()
                    .ignoresSafeArea()
                    .onTapGesture { isAmountFocused = false }
                
                // 2. Formulaire
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        
                        // Titre
                        Text(initialTransaction != nil ? "Modifier" : "Nouvelle entrée")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                        
                        // Sélecteur Type (Dépense / Recette)
                        TransactionSegmentControl(selectedIndex: $pickerSelected)
                            .padding(.horizontal, 24)
                        
                        // Carte Montant & Icône
                        HStack(spacing: 16) {
                            // Bouton Icône
                            Button {
                                showCategorySheet = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(.white.opacity(0.1))
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                    
                                    Image(editableTransaction.iconName.resource)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 80, height: 80)
                            }
                            
                            // Champ Montant
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Montant")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.6))
                                    .textCase(.uppercase)
                                
                                HStack(spacing: 4) {
                                    TextField("0.00", value: Binding(
                                        get: { abs(editableTransaction.amount) },
                                        set: { editableTransaction.amount = abs($0) }
                                    ), format: .number.precision(.fractionLength(2)))
                                    .keyboardType(.decimalPad)
                                    .focused($isAmountFocused)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    
                                    Text("€")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 80)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white.opacity(0.1))
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(isAmountFocused ? .white.opacity(0.5) : .white.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Autres Champs
                        VStack(spacing: 16) {
                            LiquidTextField(placeholder: "Nom de la transaction", text: $editableTransaction.name, icon: "pencil")
                            
                            LiquidTextField(placeholder: "Commerçant / Tiers", text: $editableTransaction.contractor, icon: "building.2")
                            
                            // Champ Date
                            Button {
                                showDatePicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.white.opacity(0.7))
                                    Text(editableTransaction.date.formatted(date: .long, time: .omitted))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                        
                        // Bouton Action (Enregistrer)
                        Button {
                            saveTransaction()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(isFormValid ? Color.blue : Color.gray.opacity(0.3))
                                    .shadow(color: isFormValid ? Color.blue.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
                                
                                if accountVM.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Enregistrer")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(height: 56)
                        }
                        .disabled(!isFormValid || accountVM.isLoading)
                        .padding(.horizontal, 24)
                        
                        // Bouton Supprimer (si édition)
                        if initialTransaction != nil {
                            Button {
                                showDeleteAlert = true
                            } label: {
                                Text("Supprimer cette transaction")
                                    .font(.subheadline)
                                    .foregroundStyle(.red.opacity(0.8))
                                    .padding()
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button { dismiss() } label: {
                        CircleButton(icon: "xmark") // Utilisation du composant CircleButton créé précédemment
                    }
                }
            }
            // Sheet Catégories
            .sheet(isPresented: $showCategorySheet) {
                CategorySelectionSheet(selectedIcon: $editableTransaction.iconName)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    // Hack pour avoir un fond transparent/blur sur la sheet en iOS
                    .presentationBackground(.ultraThinMaterial)
            }
            // Sheet Date
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("Date", selection: $editableTransaction.date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                }
                .presentationDetents([.medium])
            }
            // Alert Suppression
            .alert("Supprimer ?", isPresented: $showDeleteAlert) {
                Button("Annuler", role: .cancel) {}
                Button("Supprimer", role: .destructive) {
                    Task {
                        if let id = initialTransaction?.id {
                            await accountVM.deleteTransaction(id)
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("Cette action est irréversible.")
            }
        }
    }
    
    // MARK: - Logic
    
    private func saveTransaction() {
        // Appliquer le signe correct selon la sélection (Dépense/Recette)
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
}

// MARK: - Subviews

struct CategorySelectionSheet: View {
    @Binding var selectedIcon: CategoryIcon
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Choisir une catégorie")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(CategoryIcon.allCases) { icon in
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(icon == selectedIcon ? Color.blue : Color.gray.opacity(0.1))
                                    .frame(width: 60, height: 60)
                                
                                Image(icon.resource)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(icon == selectedIcon ? .white : .primary)
                            }
                            .onTapGesture {
                                selectedIcon = icon
                                dismiss()
                            }
                            
                            Text(icon.name) // Assurez-vous d'avoir ajouté la propriété 'name' à l'enum
                                .font(.caption2)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}
/// 3. Sélecteur à glissière fluide
struct TransactionSegmentControl: View {
    @Binding var selectedIndex: Int
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<2) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                    }
                } label: {
                    ZStack {
                        if selectedIndex == index {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                        
                        Text(index == 0 ? "Dépense" : "Recette")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedIndex == index ? .black : .secondary)
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(4)
        .background(Color.black.opacity(0.05))
        .cornerRadius(16)
    }
}

#Preview {
    SingleTransactionView()
        .environment(AccountViewModel())
}
