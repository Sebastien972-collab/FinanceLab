//
//  OnboardingView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/09/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep: Int = 0
        
    var body: some View {
        ZStack {
            GeometryReader { geo in
                FinancialBackground()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width)
            }
            VStack(spacing: 12) {
                Image(onboardingSteps[currentStep].icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(LinearGradient.greenGradient)
                    .frame(width: 100, height: 100)
                Text(onboardingSteps[currentStep].title)
                    .font(.title)
                Text(LocalizedStringKey(onboardingSteps[currentStep].content))
                    .font(.header)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
