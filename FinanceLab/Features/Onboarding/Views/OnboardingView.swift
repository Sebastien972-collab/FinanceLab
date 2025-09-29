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
            Image(onboarding.steps[step].icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(LinearGradient.greenGradient)
                .frame(width: 100, height: 100)
            Text(onboarding.steps[step].title)
                .font(.title)
            Text(LocalizedStringKey(onboarding.steps[step].content))
                .font(.header)
                .multilineTextAlignment(.center)
        }
    }
    
    private func nextButton() -> some View {
        if onboarding.currentStep < onboarding.steps.count - 1 {
            Button(action: {
                onboarding.currentStep+=1
            }, label: {
                Text("Suivant")
            }
            )
        } else {
            Button(action: {
                // dismiss
            }, label: {
                Text("C'est parti !")
            }
            )
        }
    }
        
    var body: some View {
        ZStack {
            GeometryReader { geo in
                FinancialBackground()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width)
            }
            VStack(spacing: 32) {
                cardContent(step: onboarding.currentStep)
                nextButton()
            }
            .padding(16)
        }
    }
}

#Preview {
    OnboardingView()
}
