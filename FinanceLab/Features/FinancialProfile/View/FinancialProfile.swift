
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
                VStack(alignment: .center, spacing: 24){
                    Text("Situation personnelle et familiale")
                        .font(.title)
                        .foregroundStyle(Color.Text.contrasted)
                    HStack{
                        Text("Enfant ")
                            .font(.title2)
                        Image(.userFill)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(LinearGradient.redGradient)
                    }
                    Text("As tu des enfants à charge ?")
                        .font(.body)
                        .foregroundStyle(Color.Text.contrasted)
                    HStack{
                        Button("Oui") {}
                            .buttonStyle(FinanceButton(size: .mini))
                            
                        Button("Non") {}
                            .buttonStyle(FinanceButton(size: .mini))
                            
                    }
                    
                    CustomFieldView(
                        label: "Combien ? ",
                        text: .constant("1"),
                        state: .project
                    )
                    .frame(width: 126)
                }
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

