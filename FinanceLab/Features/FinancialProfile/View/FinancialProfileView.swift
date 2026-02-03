
//  FinancialProfile.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.


//
//  LiquidFinancialProfileView.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI

struct FinancialProfileView: View {
    @State private var viewModel = FinancialProfileViewModel()
    @FocusState private var isInputFocused: Bool
    
    // Récupération sécurisée de la question
    var currentQuestion: Question {
        viewModel.currentQuestion ?? .questionDatabase[0]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Liquide Animé
                LiquidMeshBackground()
                    .ignoresSafeArea()
                    .onTapGesture { isInputFocused = false }
                
                // 2. Contenu Centré (Carte de verre)
                VStack {
                    Spacer()
                    
                    VStack(spacing: 32) {
                        
                        // En-tête : Catégorie & Icône
                        headerSection
                        
                        // La Question
                        Text(currentQuestion.content)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            // Transition fluide lors du changement de question
                            .id("Question-\(currentQuestion.id)")
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        
                        // Champ de Saisie (Design "Gros Chiffres")
                        LiquidBigCurrencyField(text: $viewModel.textAnswer)
                            .focused($isInputFocused)
                        
                        // Bouton d'action
                        actionButton
                    }
                    .padding(30)
                    .background(.ultraThinMaterial) // Glassmorphism
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            // Toolbar pour fermer le clavier numérique
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("OK") { isInputFocused = false }
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                }
            }
            // Animation globale des changements d'état
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentQuestion.id)
            .task {
                // Initialisation si besoin (ex: fetch des questions)
                 await viewModel.fetchQuestions()
            }
        }
    }
    
    // MARK: - Sections Visuelles
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Aura lumineuse derrière l'icône
                Circle()
                    .fill(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom).opacity(0.3))
                    .frame(width: 80, height: 80)
                    .blur(radius: 15)
                
                // Icône originale (redimensionnée)
                currentQuestion.questionGroup.icon.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 4) {
                Text(currentQuestion.questionGroup.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(2) // Espacement des lettres "Premium"
                    .foregroundStyle(.white.opacity(0.6))
                
                Text(currentQuestion.questionGroup.titlePrefix)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var actionButton: some View {
        Button {
            submitAnswer()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                
                if viewModel.isWorking {
                    ProgressView().tint(.white)
                } else {
                    Text("Valider")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 60)
        }
        .disabled(viewModel.textAnswer.isEmpty || viewModel.isWorking)
        .opacity(viewModel.textAnswer.isEmpty ? 0.5 : 1)
        .scaleEffect(viewModel.isWorking ? 0.98 : 1)
        .animation(.easeInOut, value: viewModel.textAnswer.isEmpty)
    }
    
    // MARK: - Logic
    
    private func submitAnswer() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        Task {
            await viewModel.saveAnswer()
            // Reset du champ ou focus automatique pour la suite peut être géré ici
        }
    }
}

// MARK: - Composant UI Spécifique

/// Un champ de saisie monétaire géant, centré et épuré
struct LiquidBigCurrencyField: View {
    @Binding var text: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            TextField("0", text: $text)
                .keyboardType(.decimalPad)
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(minWidth: 50)
                .fixedSize(horizontal: true, vertical: false)
            
            Text("€")
                .font(.system(size: 30, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.05))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}
#Preview {
    FinancialProfileView()
}
