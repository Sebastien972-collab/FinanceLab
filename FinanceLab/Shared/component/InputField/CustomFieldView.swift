//
//  ProjectTextField.swift
//  FinanceLab
//
//  Created by Dembo on 29/09/2025.
//


import SwiftUI

struct CustomFieldView: View {
    enum FieldState {
        case amount     // Label à gauche, valeur en gras
        case standard   // Label à gauche, zone texte normale
        case project    // Label en haut, zone texte en dessous
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
                TextField(placeholder, text: $text)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .frame(width: 250, height: 42)
                    .background(Color.Segmented.background)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    

            }
            .padding(.horizontal)
            
        case .standard:
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(Color.Text.contrasted)

                Spacer()
                
                TextField(placeholder, text: $text)
                    .font(.body)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .frame(width: 250, height: 42)
                    .background(Color.Segmented.background)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .padding(.horizontal)
            
        case .project:
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(Color.Text.contrasted)
                
                TextField(placeholder, text: $text)
                    .font(.body)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .frame(width: 250, height: 42)
                    .background(Color.Segmented.background)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .padding(.horizontal)
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
