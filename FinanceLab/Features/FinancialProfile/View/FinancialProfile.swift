
//  FinancialProfile.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.


//import SwiftUI
//
//struct FinancialProfile: View {
//    var body: some View {
//        VStack {
//            Spacer()
//            QuestionCard {
//                VStack(alignment: .center, spacing: 24){
//                    Text("Situation personnelle et familiale")
//                        .font(.title)
//                        .foregroundStyle(Color.Text.contrasted)
//                    HStack{
//                        Text("Enfant ")
//                            .font(.title2)
//                        Image(.userFill)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height: 30)
//                            .foregroundStyle(LinearGradient.redGradient)
//                    }
//                    Text("As tu des enfants à charge ?")
//                        .font(.body)
//                        .foregroundStyle(Color.Text.contrasted)
//                    HStack{
//                        Button("Oui") {}
//                            .buttonStyle(FinanceButton(size: .mini))
//                            
//                        Button("Non") {}
//                            .buttonStyle(FinanceButton(size: .mini))
//                            
//                    }
//                    
//                    CustomFieldView(
//                        label: "Combien ? ",
//                        text: .constant("1"),
//                        state: .project
//                    )
//                    .frame(width: 126)
//                }
//            }
//            
//            Spacer()
//           
//                .padding(.horizontal)
//        }
//        .background {
//            FinancialBackground().ignoresSafeArea()
//        }
//    }
//}
//
//#Preview {
//    FinancialProfile()
//}

import SwiftUI

struct FinancialProfile: View {
    @State private var viewModel = FinancialProfileViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            if let question = viewModel.currentQuestion {
                QuestionCard {
                    VStack(alignment: .center, spacing: 24) {
                        
                        // Titre de la catégorie
                        Text(question.questionGroup.rawValue)
                            .font(.title)
                            .foregroundStyle(Color.Text.contrasted)
                        
                        // Icône de la catégorie
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
                            .multilineTextAlignment(.center)
                        
                        // Boutons Oui / Non
                        HStack {
                            Button("Oui") {
                                viewModel.saveAnswer("Oui", for: question)
                                viewModel.nextQuestion()
                            }
                            .buttonStyle(FinanceButton(size: .mini))
                            
                            Button("Non") {
                                viewModel.saveAnswer("Non", for: question)
                                viewModel.nextQuestion()
                            }
                            .buttonStyle(FinanceButton(size: .mini))
                        }
                        
                        // Exemple de champ texte
                        if question.content.contains("Combien") {
                            CustomFieldView(
                                label: "Combien ?",
                                text: Binding(
                                    get: { viewModel.answers[question.id] ?? "" },
                                    set: { viewModel.saveAnswer($0, for: question) }
                                ),
                                state: .project
                            )
                            .frame(width: 126)
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Aucune question trouvée")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Navigation (Précédent / Suivant)
            HStack {
                if viewModel.currentQuestionIndex > 0 {
                    Button("Précédent") {
                        viewModel.previousQuestion()
                    }
                    .buttonStyle(FinanceButton(size: .mini))
                }
                
                Spacer()
                
                if !viewModel.isLastQuestion {
                    Button("Suivant") {
                        viewModel.nextQuestion()
                    }
                    .buttonStyle(FinanceButton(size: .mini))
                }
            }
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
