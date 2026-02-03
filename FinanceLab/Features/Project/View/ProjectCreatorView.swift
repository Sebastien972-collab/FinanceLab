//
//  LiquidProjectCreatorView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//  Refactored by Gemini (Liquid UI Expert) 2026
//

import SwiftUI

struct ProjectCreatorView: View {
    // Utilisation de @Bindable pour que la vue réagisse aux changements du @Observable ViewModel
    @Bindable var projectManager: ProjectCreatorViewModel
    
    @Environment(\.dismiss) private var dismiss
    var action: (() -> Void)? = nil
    
    // UI State
    @FocusState private var focusedField: Field?
    @State private var showIconPicker = false
    @State private var showDatePicker = false
    @State private var showDeleteAlert = false
    
    enum Field {
        case name, amount
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Liquide
                LiquidMeshBackground()
                    .ignoresSafeArea()
                    .onTapGesture { focusedField = nil }
                
                // 2. Formulaire
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        
                        // Titre
                        Text(projectManager.isEditing ? "Modifier le projet" : "Nouveau Projet")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                        
                        // Section 1 : Identité (Nom + Icône)
                        HStack(spacing: 16) {
                            // Sélecteur d'Icône
                            Button {
                                showIconPicker = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                    
                                    Image(projectManager.selectedIcon.resource)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 64, height: 64)
                            }
                            
                            // Champ Nom
                            LiquidTextField(placeholder: "Nom du projet", text: $projectManager.name, icon: nil)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .amount }
                        }
                        
                        // Section 2 : Objectif (Gros Montant)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("OBJECTIF")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                                .tracking(1)
                            
                            HStack(alignment: .center, spacing: 4) {
                                TextField("0", text: $projectManager.stringGoalAmount)
                                    .keyboardType(.decimalPad)
                                    .focused($focusedField, equals: .amount)
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                
                                Text("€")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical, 20)
                            .background(.white.opacity(0.05))
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(focusedField == .amount ? .white.opacity(0.5) : .white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Section 3 : Date Cible
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DATE CIBLE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                                .tracking(1)
                            
                            Button {
                                showDatePicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.cyan)
                                    Text(projectManager.finalDate.formatted(date: .long, time: .omitted))
                                        .foregroundStyle(.white)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.3))
                                }
                                .padding()
                                .background(.white.opacity(0.1))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                            }
                        }
                        
                        Spacer(minLength: 40)
                        
                        // Bouton Valider
                        Button {
                            validateForm()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(projectManager.isFormValid ? Color.blue : Color.gray.opacity(0.3))
                                    .shadow(color: projectManager.isFormValid ? Color.blue.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
                                
                                if projectManager.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Enregistrer")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(height: 56)
                        }
                        .disabled(!projectManager.isFormValid || projectManager.isLoading)
                        
                        // Bouton Supprimer (si édition)
                        if projectManager.isEditing {
                            Button {
                                showDeleteAlert = true
                            } label: {
                                Text("Supprimer ce projet")
                                    .font(.subheadline)
                                    .foregroundStyle(.red.opacity(0.8))
                                    .padding()
                            }
                        }
                    }
                    .padding(24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                        .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("OK") { focusedField = nil }
                            .fontWeight(.bold)
                    }
                }
            }
            // Sheet Icones
            .sheet(isPresented: $showIconPicker) {
                CategorySelectionSheet(selectedIcon: $projectManager.selectedIcon)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.ultraThinMaterial)
            }
            // Sheet Date
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("Date de fin", selection: $projectManager.finalDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    
                    Button("Valider") { showDatePicker = false }
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(30)
            }
            // Alert Error
            .alert("Oups", isPresented: $projectManager.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(projectManager.error.localizedDescription)
            }
        }
    }
    
    // MARK: - Logic
    
    private func validateForm() {
        focusedField = nil
        Task {
            if projectManager.isEditing {
                // Cas Édition : on doit récupérer le projet original quelque part ou le passer
                // Ici on suppose que le ViewModel gère l'update via une méthode dédiée ou que le parent gère
                // Note : Pour l'édition, il faudrait idéalement passer le projet complet au VM
                await projectManager.validate {
                    dismiss()
                    action?()
                }
            } else {
                // Cas Création
                await projectManager.validate {
                    dismiss()
                    action?()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProjectCreatorView(projectManager: ProjectCreatorViewModel())
}
