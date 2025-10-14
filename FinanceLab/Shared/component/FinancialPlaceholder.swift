//
//  FinancialPlaceholder.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct FinancialPlaceholder: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.App.background)
            Image(.handCoinsFill)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150)
                .foregroundStyle(Color.Text.contrasted)
        }
        .frame(height: 300)
        .opacity(0.3)
        .clipped()
    }
}

#Preview {
    FinancialPlaceholder()
        .background {
            FinancialBackground().ignoresSafeArea()
        }
}
