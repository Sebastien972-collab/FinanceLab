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
        VStack {
            HStack {
                Spacer()
                Image(onboarding.steps[step].icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(LinearGradient.greenGradient)
                Spacer()
            }
                .frame(height: 100)
            Text(onboarding.steps[step].title)
                .font(.title)
            Text(LocalizedStringKey(onboarding.steps[step].content))
                .font(.header)
                .multilineTextAlignment(.center)
                .frame(height: 150)
        }
        .frame(height: 500)
        .padding(.horizontal, 16)
        .foregroundStyle(Color.Text.contrasted)
        .background(Color.white.opacity(0.2))
        .cornerRadius(100)
    }
    
    private func nextButton() -> some View {
        if onboarding.currentStep < onboarding.steps.count - 1 {
            ContinuButtonView(title: "Suivant", state: .normal, action: {
                onboarding.currentStep += 1
            })
        } else {
            ContinuButtonView(title: "C'est parti !", state: .validate, action: {
                // dismiss
            })
        }
    }
        
    var body: some View {
        VStack {
            Spacer()
            cardContent(step: onboarding.currentStep)
                .animation(.easeInOut(duration: 0.5), value: onboarding.currentStep)
            Spacer()
            nextButton()
        }
        .padding(16)
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
}
