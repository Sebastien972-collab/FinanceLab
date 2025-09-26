//
//  SaveDeleteButton.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI

struct SaveDeleteButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 120, height: 44)
                .background(LinearGradient.greenGradient)
                .clipShape(RoundedRectangle(cornerRadius: 30))
    
        }
        .padding(.horizontal)
    }
}

#Preview {
    SaveDeleteButton(
        title: "Enregistrer",
        action: {}
    )
}
