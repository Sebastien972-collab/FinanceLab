//
//  ProjectTextField.swift
//  FinanceLab
//
//  Created by Dembo on 29/09/2025.
//


import SwiftUI

struct CustomFieldView: View {
    enum FieldState {
        case amount
        case standard
        case project
    }
    
    var label: String
    @Binding var text: String
    var placeholder: String = ""
    var state: FieldState = .standard
    
    var body: some View {
        switch state {
        case .amount:
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(Color.Text.contrasted)
                Spacer()
                CustomTextFieldView(placeholder: placeholder, text: $text, isBold: true)
            }
            .padding(.horizontal)
        case .standard:
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(Color.Text.contrasted)
                Spacer()
                CustomTextFieldView(placeholder: placeholder, text: $text)
                
            }
            .padding(.horizontal)
            
        case .project:
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(Color.Text.contrasted)
                    .padding(.leading)
                CustomTextFieldView(placeholder: placeholder, text: $text)
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        CustomFieldView(
            label: "Montant",
            text: .constant("- 42,24 €"),
            state: .amount
        )
        
        CustomFieldView(
            label: "Nom",
            text: .constant("Assurance"),
            state: .standard
        )
        
        CustomFieldView(
            label: "Nom du projet",
            text: .constant("Voiture"),
            state: .project
        )
    }
    .padding()
}
