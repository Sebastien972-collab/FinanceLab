//
//  LiquidOnboardingView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/09/2025.
//  Refactored by Gemini (Liquid UI Expert) 2026
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - State & Props
    // On transforme le Flow en State pour que la vue se rafraîchisse
    @State private var currentStep = 0
    @Environment(TabViewModel.self) private var tabVm
    
    // Données simulées pour l'exemple (à remplacer par votre OnboardingFlow)
    let steps: [OnboardingStep] = [
        OnboardingStep(icon: "sparkles", title: "Bienvenue", content: "Découvrez une nouvelle façon de gérer vos finances avec élégance et fluidité."),
        OnboardingStep(icon: "chart.bar.fill", title: "Analysez", content: "Visualisez vos dépenses en temps réel grâce à des graphiques intuitifs."),
        OnboardingStep(icon: "lock.shield.fill", title: "Sécurisez", content: "Vos données sont protégées avec les meilleurs standards de sécurité.")
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // 1. Fond Liquide (Réutilisation du composant Login)
            LiquidMeshBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (Skip button)
                HStack {
                    Spacer()
                    if currentStep < steps.count - 1 {
                        Button("Passer") {
                            withAnimation { completeOnboarding() }
                        }
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.subheadline)
                        .padding(.top, 20)
                        .padding(.trailing, 24)
                    }
                }
                
                // 2. Carousel de Cartes (Swipeable)
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        OnboardingCardView(step: steps[index])
                            .tag(index)
                            .padding(.horizontal, 20)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                VStack(spacing: 30) {
                    // Indicateurs personnalisés
                    HStack(spacing: 8) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Capsule()
                                .fill(currentStep == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: currentStep == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentStep)
                        }
                    }
                    Button {
                        handleNext()
                    } label: {
                        Text(currentStep == steps.count - 1 ? "C'est parti !" : "Suivant")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.vertical, 16)
                            .frame(width: 300, height: 60)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                    }
                    .padding()
                }
            }
        }
        .transition(.opacity)
    }
    
    // MARK: - Logic
    
    private func handleNext() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if currentStep < steps.count - 1 {
                currentStep += 1
            } else {
                completeOnboarding()
            }
        }
    }
    
    private func completeOnboarding() {
        // Haptic feedback pour valider
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        withAnimation {
            tabVm.authState = .questionPhase
        }
    }
}

// MARK: - Subviews

struct OnboardingCardView: View {
    let step: OnboardingStep
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Icône flottante
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .blur(radius: 10)
                
                Image(systemName: step.icon) // Remplacez par vos Assets : Image(step.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: isAnimating) // Animation native SF Symbols
            }
            .offset(y: isAnimating ? -10 : 10) // Effet de lévitation
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            
            VStack(spacing: 16) {
                Text(step.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(LocalizedStringKey(step.content))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineSpacing(4)
                    .padding(.horizontal, 10)
            }
        }
        .padding(40)
        .background(.ultraThinMaterial) // Effet verre
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Models (Mock)
// Ajoutez ceci si vous n'avez pas accès à votre classe OnboardingFlow originale
struct OnboardingStep: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let content: String
}

#Preview {
    OnboardingView()
        .environment(TabViewModel())
}
