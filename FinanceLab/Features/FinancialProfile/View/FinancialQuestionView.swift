
//  FinancialProfile.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.

import SwiftUI

struct FinancialQuestionView: View {
    @Environment(TabViewModel.self) private var tabVm: TabViewModel
    @State private var viewModel = FinancialProfileViewModel()
    var currentQuestion: Question {
        viewModel.currentQuestion ?? Question.questionDatabase[0]
    }
    var body: some View {
        VStack {
            Spacer()
            QuestionCard {
                VStack(alignment: .center, spacing: 24) {
                    // Titre et icône
                    Text(currentQuestion.questionGroup.rawValue)
                        .font(.title)
                        .foregroundStyle(Color.Text.contrasted)
                    HStack {
                        Text(currentQuestion.questionGroup.displayName)
                            .font(.title2)
                        currentQuestion.questionGroup.icon.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(LinearGradient.redGradient)
                    }
                    // Texte de la question
                    Text(currentQuestion.content)
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
                            Task {
                                await viewModel.saveAnswer {
                                    tabVm.authState = .notAuthenticated
                                }
                            }
                        }
                        .buttonStyle(FinanceButton(size: .mini))
                }
            }
            
            Spacer()
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
        .task {
            await viewModel.fetchQuestions()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button {} label: {
                Text("Ok")
            }
        } message: {
            Text(viewModel.error.localizedDescription)
        }
    }
}

#Preview {
    FinancialQuestionView()
        .environment(TabViewModel())
}
