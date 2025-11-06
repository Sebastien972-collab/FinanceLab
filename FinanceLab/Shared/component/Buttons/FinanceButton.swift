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
        case round, mini, normal, large, delete
    }
    
    init(state: ButtonState = .normal, size: ButtonSize = .normal) {
        self.state = state
        self.size = size
    }
        
    private func getForegroundColor() -> Color {
        if state == .normal {
            return Color.Text.quaternary
        } else {
            return Color.Text.primary
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
            case .round: return 38
            case .mini: return 42
            case .large: return 64
            case .delete: return 64
            default: return 42
        }
    }
    private func getButtonWidth() -> CGFloat {
        switch size {
            case .round: return 38
            case .mini: return 120
            case .large: return 152
            case .delete: return 42
            default: return 200
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if size == .round {
                    configuration.label
                        .frame(width: 22, height: 22)
                        .padding(0)
                } else {
                    configuration.label
                        .padding(.horizontal, 12)
                }
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
        .frame(height: getButtonHeight())
        .frame(minWidth: 0, maxWidth: size == .normal ? .infinity : getButtonWidth())
        .scaleEffect (configuration.isPressed ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.05), value: configuration.isPressed)
    }
}

#Preview {
    Button("<") {}
        .buttonStyle(FinanceButton(size: .round))
        .padding()
}
