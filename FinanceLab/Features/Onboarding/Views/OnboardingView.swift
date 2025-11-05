//
//  OnboardingView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/09/2025.
//

import SwiftUI

struct OnboardingView: View {
    let onboarding = OnboardingFlow()
        
    private func cardContent(step: Int) -> some View {
        VStack(spacing: 12) {
            Image(onboarding.steps[step].icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(LinearGradient.greenGradient)
                .frame(height: 60)
            Text(onboarding.steps[step].title)
                .font(.title)
            Text(LocalizedStringKey(onboarding.steps[step].content))
                .font(.header)
                .multilineTextAlignment(.center)
                .frame(height: 100)
        }
    }
    
    private func nextButton() -> some View {
        if onboarding.currentStep < onboarding.steps.count - 1 {
            Button("Suivant") {
                onboarding.currentStep += 1
            }
            .buttonStyle(FinanceButton())
        } else {
            Button("C'est parti !") {
                // dismiss
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                tabVm.authState = .questionPhase
            }
            .buttonStyle(FinanceButton(state: .validate))
        }
    }
    @Environment(TabViewModel.self) private var tabVm: TabViewModel
    var body: some View {
        VStack {
            Spacer()
            OnboardingCard {
                cardContent(step: onboarding.currentStep)
            }
            .padding()
            Spacer()
            nextButton()
                .padding(.horizontal)
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
        .environment(TabViewModel())
}
