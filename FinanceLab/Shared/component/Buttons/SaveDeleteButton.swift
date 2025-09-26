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
        ContinuButtonView(title: "Enregistrer", state: .validate) {
            action()
        }
        .frame(width: 160, height: 44)
    }
}

#Preview {
    SaveDeleteButton(
        title: "Enregistrer",
        action: {}
    )
}
