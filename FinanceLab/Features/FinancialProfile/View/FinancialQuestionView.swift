
//  FinancialProfile.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.

import SwiftUI

struct FinancialQuestionView: View {
    @Environment(TabViewModel.self) private var tabVm: TabViewModel
    @Environment(\.dismiss) private var dismiss
    @State var viewModel = FinancialProfileViewModel()
    var currentQuestion: Question {
        viewModel.currentQuestion ?? Question.questionDatabase[0]
    }
    var isNewQuestion: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            QuestionCard {
                VStack(alignment: .center, spacing: 24) {
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
                    
                    // Si pas de choix prédéfinis → champ texte libre
                    CustomFieldView(
                        label: currentQuestion.followUpLabel ?? "Réponse",
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
            .font(.body)
            .foregroundStyle(Color.Text.contrasted)
            .padding()
            
            Spacer()
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
        .task {
            viewModel.isNewQuestion = isNewQuestion
            viewModel.action = { dismiss() }
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
