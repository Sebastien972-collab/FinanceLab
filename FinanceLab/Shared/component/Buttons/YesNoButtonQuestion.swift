//
//  YesNoButtonQuestion.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI


struct YesNoButtonQuestion: View {
    var title: String
    
    enum ButtonState {
        case normal, validate
    }
    var state: ButtonState = .normal
    var action: () -> Void
   @State private var textColor = Color.white
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .frame(width: 126, height: 46)
                .padding()
                .background(getColor())
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .padding(.horizontal)
        .onAppear(){
            if state == .normal{
                textColor = .black
            }
        }
        
    }
   private func getColor() -> LinearGradient {
        switch state {
        case .normal:
          
            return LinearGradient.primaryGradient
        case .validate:
            return LinearGradient.greenGradient
       
        }
        
    }
}



#Preview {
    VStack{
        YesNoButtonQuestion(
            title: "Non",
            action: {}
        )
        
        YesNoButtonQuestion(
            title: "Oui",
            state: .validate,
            action: {}
        )
        
    }
}
