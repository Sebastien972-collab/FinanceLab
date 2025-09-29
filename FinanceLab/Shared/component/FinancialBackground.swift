//
//  BackgroundView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 25/09/2025.
//

import SwiftUI

// Use it in your views like this :
//
// ZStack {
//     FinancialBackground().ignoresSafeArea()
//     // your content goes here
// }

struct FinancialBackground: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.App.background)
            VStack {
                Image(.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Spacer()
            }
        }
    }
}

#Preview {
    FinancialBackground()
}

