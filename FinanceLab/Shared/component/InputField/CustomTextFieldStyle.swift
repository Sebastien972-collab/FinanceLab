//
//  CustomTextFieldStyle.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    enum TextFieldFontSize {
        case normal
        case big
    }
    
    var fontSize : TextFieldFontSize = .normal
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(fontSize == .big ? Font.inputFieldNumber : Font.inputFieldText)
            .multilineTextAlignment(.trailing)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .frame(height: 42)
            .background(Color.Segmented.background)
            .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}
