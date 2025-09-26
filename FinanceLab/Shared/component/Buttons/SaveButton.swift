//
//  SaveButton.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI

struct SaveButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 120, height: 44)
                .padding()
                .background(LinearGradient.greenGradient)
                .cornerRadius(30)
        }
        .padding(.horizontal)
    }
}



#Preview {
    SaveButton(
        title: "Enregistrer",
        action: {}
    )
}
