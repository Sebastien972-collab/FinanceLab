//
//  RecalculateButton.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI


struct RecalculateButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 370, height: 46)
                .padding()
                .background(LinearGradient.primaryGradient)
                .cornerRadius(30)
        }
        .padding(.horizontal)
    }
}



#Preview {
    RecalculateButton(
        title: "Recalculer",
        action: {}
    )
}
