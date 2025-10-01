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
                HeaderView(label: label)
                Spacer()
                CustomTextFieldView(placeholder: placeholder, text: $text, isBold: true)
            }
            .padding(.horizontal)
        case .standard:
            HStack {
                HeaderView(label: label)
                Spacer()
                CustomTextFieldView(placeholder: placeholder, text: $text)
                
            }
            .padding(.horizontal)
            
        case .project:
            VStack(alignment: .leading, spacing: 8) {
                HeaderView(label: label)
                CustomTextFieldView(placeholder: placeholder, text: $text)
            }
            .padding(.horizontal)
        }
    }
   
}

fileprivate struct HeaderView: View {
    var label: String
    var body: some View {
        Text(label)
            .font(Font.listHeader)
            .foregroundColor(Color.Text.contrasted)
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
