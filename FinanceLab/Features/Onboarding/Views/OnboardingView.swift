//
//  OnboardingView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/09/2025.
//

import SwiftUI

struct OnboardingView: View {
    let onboarding = Onboarding()
    @State private var currentStep: Int = 0
        
    var body: some View {
        ZStack {
            GeometryReader { geo in
                FinancialBackground()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width)
            }
            VStack(spacing: 12) {
                Spacer()
                Image(onboarding.steps[currentStep].icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(LinearGradient.greenGradient)
                    .frame(width: 100, height: 100)
                Text(onboarding.steps[currentStep].title)
                    .font(.title)
                Text(LocalizedStringKey(onboarding.steps[currentStep].content))
                    .font(.header)
                    .multilineTextAlignment(.center)
                Spacer()
                if currentStep < onboarding.steps.count - 1 {
                    Button(action: {
                        currentStep+=1
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
        }
    }
}

#Preview {
    OnboardingView()
}
