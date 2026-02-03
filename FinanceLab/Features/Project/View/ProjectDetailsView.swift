//
//  LiquidProjectDetailsView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 05/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI
import FinanceCore

struct ProjectDetailsView: View {
    @State var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(ProjectViewModel.self) private var projectVM
    
    @State private var creatorVM = ProjectCreatorViewModel()
    @State private var showAddAmountSheet = false
    @State private var showEditSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Animé
                LiquidMeshBackground()
                    .ignoresSafeArea()
                
                // 2. Icône Géante en Fond (Ambiance)
                if let iconName = project.iconName, let icon = CategoryIcon(rawValue: iconName) {
                    Image(icon.resource)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .blur(radius: 60) // Effet de lueur diffuse
                        .opacity(0.3)
                        .offset(x: 100, y: -200)
                }
                
                // 3. Contenu Défilant
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // En-tête
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Projet")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                                .textCase(.uppercase)
                            
                            Text(project.name)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Carte Principale (Progression)
                        progressCard
                        
                        // Cartes Détails (Grid)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            LiquidDetailCard(title: "Épargne/Mois", value: "\(project.monthlyAmount.formatted(.number.precision(.fractionLength(0)))) €", icon: "calendar")
                            LiquidDetailCard(title: "Restant", value: "\(project.numberOfMonthsToReachGoal) mois", icon: "hourglass")
                            LiquidDetailCard(title: "Objectif", value: project.deadlineFormatted, icon: "flag.checkered")
                            LiquidDetailCard(title: "Montant", value: "\(project.goalAmount.formatted(.number.notation(.compactName))) €", icon: "target")
                        }
                        .padding(.horizontal, 24)
                        
                        // Bouton Action Principal
                        Button {
                            showAddAmountSheet = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                                
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Ajouter à ma cagnotte")
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 18, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.vertical, 16)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button { dismiss() } label: {
                        CircleButton(icon: "chevron.left")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        creatorVM.setupForEditing(project: project)
                        showEditSheet = true
                    } label: {
                        CircleButton(icon: "pencil")
                    }
                }
            }
            // Sheet Ajout Montant
            .sheet(isPresented: $showAddAmountSheet) {
                LiquidAddAmountSheet(project: $project) { addedAmount in
                    saveAmountChange()
                }
                .presentationDetents([.fraction(0.35)])
                .presentationBackground(.ultraThinMaterial)
            }
            // Sheet Édition
            .sheet(isPresented: $showEditSheet) {
                ProjectCreatorView(projectManager: creatorVM, action: {
                    // Refresh project data locally
                    if let updated = projectVM.projects.first(where: { $0.id == project.id }) {
                        self.project = updated
                    }
                })
            }
            .presentationDetents([.medium, .large])
            .presentationBackground(.ultraThinMaterial)
        }
    }
    
    // MARK: - Subviews
    
    private var progressCard: some View {
        VStack(spacing: 20) {
            // Jauge Circulaire
            ZStack {
                // Fond
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 15)
                    .frame(width: 180, height: 180)
                
                // Progression
                Circle()
                    .trim(from: 0, to: CGFloat(project.progressPercentage / 100))
                    .stroke(
                        LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: project.amountSaved)
                
                // Texte Central
                VStack(spacing: 4) {
                    Text("\(Int(project.progressPercentage))%")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Complété")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                }
            }
            .padding(.top, 10)
            
            // Montants
            HStack {
                VStack(alignment: .leading) {
                    Text("Actuel")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                    Text("\(project.amountSaved.formatted(.number.precision(.fractionLength(0)))) €")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Cible")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                    Text("\(project.goalAmount.formatted(.number.precision(.fractionLength(0)))) €")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
    
    // MARK: - Logic
    
    private func saveAmountChange() {
        Task {
            // Update via VM
            try await projectVM.updateProject(with: project)
        }
    }
}

// MARK: - Components

struct LiquidDetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.8))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct LiquidAddAmountSheet: View {
    @Binding var project: Project
    var onSave: (Decimal) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var amountText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Ajouter une épargne")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.top, 20)
            
            HStack(spacing: 4) {
                TextField("0", text: $amountText)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
                
                Text("€")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Button {
                if let amount = Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")) {
                    project.amountSaved += amount
                    onSave(amount)
                    dismiss()
                }
            } label: {
                Text("Valider")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(amountText.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(16)
            }
            .disabled(amountText.isEmpty)
            .padding(.horizontal, 24)
        }
        .onAppear { isFocused = true }
    }
}

#Preview {
    ProjectDetailsView(project: Project.preview)
        .environment(ProjectViewModel())
}
