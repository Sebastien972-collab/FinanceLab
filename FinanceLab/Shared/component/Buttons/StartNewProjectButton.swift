//
//  StartNewProjectButton.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI


struct StartNewProjectButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 370, height: 80)
                .padding()
                .background(LinearGradient.greenGradient)
                .cornerRadius(30)
        }
        .padding(.horizontal)
    }
}



#Preview {
    StartNewProjectButton(
        title: "Démarrer un nouveau projet",
        action: {}
    )
}
