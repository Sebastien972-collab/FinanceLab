//
//  LiquidFinancialQuestionView.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI

struct FinancialQuestionView: View {
    @Environment(TabViewModel.self) private var tabVm
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = FinancialProfileViewModel()
    @FocusState private var isInputFocused: Bool
    
    var currentQuestion: Question {
        viewModel.currentQuestion ?? Question.questionDatabase[0]
    }
    
    var isNewQuestion: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidMeshBackground()
                    .ignoresSafeArea()
                    .onTapGesture { isInputFocused = false }
                VStack {
                    Spacer()
                    VStack(spacing: 30) {
                        headerSection
                        Text(currentQuestion.content)
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)
                            .id("QuestionText-\(currentQuestion.id)")
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        LiquidCurrencyField(
                            label: currentQuestion.followUpLabel ?? "Montant",
                            text: $viewModel.textAnswer
                        )
                        .focused($isInputFocused)
                        .onSubmit {
                            submitAnswer()
                        }
                        actionButton
                    }
                    .padding(.vertical, 40)
                    .padding(.horizontal, 24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 25, x: 0, y: 15)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    if viewModel.isWorking {
                         ProgressView().tint(.white)
                            .padding(.bottom, 20)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") { isInputFocused = false }
                        .fontWeight(.bold)
                }
            }
        }
        .task {
            viewModel.isNewQuestion = isNewQuestion
            viewModel.action = { dismiss() }
            await viewModel.fetchQuestions()
        }
        .alert("Oups", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.error.localizedDescription)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentQuestion.id)
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.3))
                    .frame(width: 70, height: 70)
                    .blur(radius: 10)
                currentQuestion.questionGroup.icon.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .foregroundStyle(.white)
            }
            
            Text(currentQuestion.questionGroup.displayName.uppercased())
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(2) // Espacement des lettres style "Luxe"
                .foregroundStyle(.white.opacity(0.7))
        }
    }
    
    private var actionButton: some View {
        Button {
            submitAnswer()
        } label: {
            Text("Valider")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(16)
        }
        .disabled(viewModel.isWorking)
        .opacity(viewModel.isWorking ? 0.7 : 1)
        .scaleEffect(viewModel.isWorking ? 0.98 : 1)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                .frame(width: 300, height: 60)
        }
        
    }
    
    // MARK: - Logic
    
    private func submitAnswer() {
        // Petit retour haptique
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        isInputFocused = false
        
        Task {
            await viewModel.saveAnswer {
                withAnimation {
                    tabVm.authState = .notAuthenticated
                }
            }
        }
    }
}

// MARK: - Composant : Champ Monétaire Liquide
// Spécialement conçu pour l'entrée de chiffres avec style
struct LiquidCurrencyField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Text("€") // Ou symbole dynamique selon la locale
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white.opacity(0.8))
            
            TextField("", text: $text, prompt: Text(label).foregroundColor(.white.opacity(0.4)))
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    FinancialQuestionView()
        .environment(TabViewModel())
}
