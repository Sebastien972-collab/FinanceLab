//
//  FinanceButton.swift
//  FinanceLab
//
//  Created by Anne Ferret on 03/10/2025.
//

import SwiftUI

struct FinanceButton: ButtonStyle {
    let state: ButtonState?
    let size: ButtonSize?
    
    enum ButtonState {
        case normal, validate, cancel
    }
    
    enum ButtonSize {
        case mini, normal, large
    }
    
    init(state: ButtonState = .normal, size: ButtonSize = .normal) {
        self.state = state
        self.size = size
    }
        
    private func getForegroundColor() -> Color {
        if state == .normal {
            Color.Text.quaternary
        } else {
            Color.Text.primary
        }
    }
    
    private func getBackgroundColor() -> LinearGradient {
        switch state {
            case .validate: LinearGradient.greenGradient
            case .cancel: LinearGradient.redGradient
            default: LinearGradient.primaryGradient
        }
    }
    
    private func getButtonHeight() -> CGFloat {
        switch size {
            case .mini: return 38
            case .normal: return 42
            case .large: return 64
            default: return 64
        }
    }
    private func getButtonWidth() -> CGFloat {
        switch size {
            case .mini: return 120
            case .normal: return .infinity
            case .large: return 152
            default: return .infinity
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                configuration.label
                    .padding(.horizontal, 12)
                Spacer()
            }
            Spacer()
        }
        .font(.buttonLabel)
        .fontWeight(.semibold)
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .foregroundColor(getForegroundColor())
        .background(getBackgroundColor())
        .cornerRadius(50)
        .frame(width: getButtonWidth(), height: getButtonHeight())
        .scaleEffect (configuration.isPressed ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.05), value: configuration.isPressed)
    }
}

#Preview {
    Button("Bonjour") {}
        .buttonStyle(FinanceButton(size: .mini))
        .padding()
}
