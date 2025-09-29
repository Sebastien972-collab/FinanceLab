
//  TextFieldsEnterExit.swift
//  FinanceLab

//  Created by Dembo on 26/09/2025.


import SwiftUI

struct TextFieldsEnterExit: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 50))        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 16) {
        TextFieldsEnterExit(label: "Montant", value: "- 42,24 €")
        
    }
    .padding()
}
