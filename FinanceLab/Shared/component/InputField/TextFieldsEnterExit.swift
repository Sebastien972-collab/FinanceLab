//
//  TextFieldsEnterExit.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI

struct TextFieldsEnterExit: View {
    @State private var text = ""
    
    var body: some View {
        HStack(spacing: 20) {
            
            Text("Montant  \(text)")
                .foregroundColor(.gray)
            
            
            TextField("Entrez votre texte ici", text: $text)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .background()
                .frame(width: 250, height: 42)
                .padding()
            
            
            
        }
        .padding()
    }
}

#Preview {
    TextFieldsEnterExit()
}
