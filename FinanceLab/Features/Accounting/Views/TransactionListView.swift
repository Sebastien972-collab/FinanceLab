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
    
    // UI State
    @State private var pickerSelected = 0
    @State private var chartPickerSelected = 0
    @State private var isLoading = false
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Liquide
                LiquidMeshBackground()
                    .ignoresSafeArea()
                
                // 2. Contenu
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                } else {
                    mainContent
                }
            }
            .toolbar { toolbarContent }
            .task {
                isLoading = true
                try? await Task.sleep(for: .milliseconds(50)) // Micro-delay pour fluidité transition
                await accountVM.initializeView()
                isLoading = false
            }
            .alert("Oups", isPresented: $accountVM.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(accountVM.error.localizedDescription)
            }
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // Titre Date
                Text(Date().formatted(.dateTime.month(.wide).year()).capitalized)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                if accountVM.transactionsList.isEmpty {
                    emptyState
                } else {
                    // Carte Graphique (Glassmorphism)
                    if accountVM.spent != 0 || accountVM.gained != 0 {
                        chartsSection
                    }
                    
                    transactionsListSection
                }
                
                Spacer(minLength: 80)
            }
        }
    }
    
    // MARK: - Sections
    
    private var emptyState: some View {
        NavigationLink(destination: SingleTransactionView().environment(accountVM)) {
            LiquidDemboCard {
                Text("Tu n'as pas encore commencé à gérer tes transactions. Enregistre la première maintenant !")
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var chartsSection: some View {
        VStack(spacing: 20) {
            HStack {
                segmentButton(title: "Budget", index: 0)
                segmentButton(title: "Catégories", index: 1)
            }
            .padding(4)
            .background(Color.black.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            // Contenu du Graphique
            ZStack {
                if pickerSelected == 0 {
                    SpendingRepartition(spent: $accountVM.spent, gained: $accountVM.gained)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    VStack(spacing: 16) {
                        if chartPickerSelected == 0 {
                            CategoryChart(transactionsChart: $accountVM.transactionsChartSpent, isSpendings: true)
                                .frame(height: 220)
                        } else {
                            CategoryChart(transactionsChart: $accountVM.transactionsChartGained, isSpendings: false)
                                .frame(height: 220)
                        }
                        
                        HStack {
                            Spacer()
                            FinancialPicker(options: ["Dépenses", "Recettes"], isTransaction: true, selected: $chartPickerSelected)
                                .frame(width: 200)
                            Spacer()
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: pickerSelected)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: chartPickerSelected)
    }
    
    private var transactionsListSection: some View {
        LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
            let grouped = Dictionary(grouping: accountVM.transactionsList) {
                Calendar.current.startOfDay(for: $0.date)
            }.sorted { $0.key > $1.key }
            
            ForEach(grouped, id: \.key) { date, transactions in
                Section {
                    ForEach(transactions) { transaction in
                        NavigationLink(destination: SingleTransactionView(transaction: transaction).environment(accountVM)) {
                            LiquidTransactionRow(transaction: transaction)
                        }
                    }
                } header: {
                    HStack {
                        Text(date.formatted(.dateTime.day().month(.wide)).capitalized)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.8))
                            .clipShape(Capsule())
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private func segmentButton(title: String, index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                pickerSelected = index
            }
        } label: {
            ZStack {
                if pickerSelected == index {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .matchedGeometryEffect(id: "TabBg", in: animation)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(pickerSelected == index ? .black : .white.opacity(0.8))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    SingleTransactionView()
                        .environment(accountVM)
                } label: {
                    CircleButton(icon: "plus")
                }
            }
        }
    }
}

// MARK: - Subviews & Helpers

/// Bouton circulaire style "Verre" pour la toolbar


#Preview {
    TransactionListView()
}
