//
//  YesNoButtonQuestion.swift
//  FinanceLab
//
//  Created by Dembo on 26/09/2025.
//

import SwiftUI


struct YesNoButtonQuestion: View {
    enum YesOrNo: String {
    case yes = "Oui"
    case no = "Non"
    }
    
    var selection: YesOrNo
    enum ButtonState {
        case normal, validate
    }
    var state: ButtonState = .normal
    var action: () -> Void
   @State private var textColor = Color.white
    
    var body: some View {
        switch selection {
        case .yes:
            ContinuButtonView(title: selection.rawValue, state: .validate, action: action)
                .frame(width: 126, height: 46)
        case .no:
            ContinuButtonView(title: selection.rawValue, state: .normal, action: action)
                .frame(width: 126, height: 46)
        }
    }
    
}



#Preview {
    VStack(spacing: 10) {
        YesNoButtonQuestion(
            selection: .no,
            state: .normal,
            action: {}
        )
        YesNoButtonQuestion(
            selection: .yes,
            state: .validate,
            action: {}
        )
    }
}
