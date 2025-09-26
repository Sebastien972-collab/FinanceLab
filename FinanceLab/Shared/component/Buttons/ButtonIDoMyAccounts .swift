//
//  ButtonIDoMyAccounts .swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI


struct ContinuButtonView: View {
    var title: String
    
    enum ButtonState {
        case normal, validate, cancel
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
                .frame(maxWidth: .infinity)
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
        case .cancel:
            return LinearGradient.redGradient
        }
        
    }
}



#Preview {
    VStack{
        ContinuButtonView(
            title: "Je fais mes comptes !",
            action: {}
        )
        
        ContinuButtonView(
            title: "Je fais mes comptes !",
            state: .validate,
            action: {}
        )
        
        ContinuButtonView(
            title: "Je fais mes comptes !",
            state: .cancel,
            action: {}
        )
        
    }
}
