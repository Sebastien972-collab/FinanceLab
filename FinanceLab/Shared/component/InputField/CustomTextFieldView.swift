//
//  CustomTextFieldView.swift
//  FinanceLab
//
//  Created by Dembo on 29/09/2025.
//

import SwiftUI

struct CustomTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    var isBold: Bool = false
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.title3)
            .bold(isBold)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 42)
            .background(Color.Segmented.background)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .padding(.horizontal)
            .minimumScaleFactor(0.9)
    }
}

#Preview {
    CustomTextFieldView(placeholder: "Montant", text: .constant(""))
}
