
//  FinancialProfile.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.




import SwiftUI

struct FinancialProfile: View {
    @State private var viewModel = FinancialProfileViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            let question = viewModel.currentQuestion
            
            QuestionCard {
                VStack(alignment: .center, spacing: 24) {
                    // Titre et icône
                    Text(question.questionGroup.rawValue)
                        .font(.title)
                        .foregroundStyle(Color.Text.contrasted)
                    
                    HStack {
                        Text(question.questionGroup.titlePrefix)
                            .font(.title2)
                        question.questionGroup.icon.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(LinearGradient.redGradient)
                    }
                    
                    // Texte de la question
                    Text(question.content)
                        .font(.body)
                        .foregroundStyle(Color.Text.contrasted)
                    
                    // Si pas de choix prédéfinis → champ texte libre
                    CustomFieldView(
                        label: "Réponse",
                        text: $viewModel.textAnswer,
                        state: .project
                    )
                    .frame(width: 200)
                        
                        Button("Valider") {
                           // viewModel.saveAnswer()
                            viewModel.nextQuestion()
                        }
                        .buttonStyle(FinanceButton(size: .mini))
                }
            }
            
            Spacer()
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    FinancialProfile()
}
