
//  FinancialProfile.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.


import SwiftUI

struct FinancialProfile: View {
    var body: some View {
        VStack {
            Spacer()
            QuestionCard {
                
            }
            
            Spacer()
           
                .padding(.horizontal)
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    FinancialProfile()
}

