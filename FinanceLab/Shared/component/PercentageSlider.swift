//
//  PercentageSlider.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

struct PercentageSlider: View {
    @State var percentage: Double
    var height: SliderHeight = .normal
    var color: SliderColor

    enum SliderHeight {
        case normal
        case big
    }
    
    enum SliderColor {
        case greenToRed
        case redToGreen
        case greenToWhite
    }
        
    var leadingColor: LinearGradient {
        switch color {
            case .greenToRed:
                return .greenGradient
            case .redToGreen:
                return .redGradient
            case .greenToWhite:
                return .greenGradient
        }
    }
    
    var trailingColor: LinearGradient {
        switch color {
            case .greenToRed:
                return .redGradient
            case .redToGreen:
                return .greenGradient
            case .greenToWhite:
                return .primaryGradient
        }
    }

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(leadingColor)
                    .frame(width: geo.size.width * percentage)
                Rectangle()
                    .fill(trailingColor)
            }
            .cornerRadius(50)
            .frame(height: height == .big ? 24 : 10)
            .onAppear {
                if percentage < 0 {
                    percentage = 0
                } else if percentage > 1 {
                    percentage = 1
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        PercentageSlider(percentage: 0.8, color: .greenToWhite)
            .padding()
    }
    .background {
        FinancialBackground().ignoresSafeArea()
    }
}
