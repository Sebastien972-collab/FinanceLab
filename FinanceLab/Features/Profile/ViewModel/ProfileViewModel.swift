//
//  ProfileViewModel.swift
//  FinanceLab
//
//  Created by Dembo on 09/10/2025.
//
//
import Foundation


@Observable
class ProfileViewModel {
    let userManager: UserManager = .shared
    var currentUser: User {
        userManager.currentUser
    }
    
    /// Base locale de réponses
    //    var userAnswers: [Answer] = Answer.userAnswerDatabase
    var userAnswers: [Answer] = []
    init() {
        
    }
    
    func fetchAnswer() async {
        do {
            let answers = try await AnswersService.shared.fetchAllUserAnswers()
            let questions = try await QuestionsService.shared.fetchQuestion()
            
            var uniqueAnswers: [Answer] = []
            
            for apiAnswer in answers {
                if let question = questions.first(where: { $0.id == apiAnswer.idQuestion }) {
                    let answerModel = apiAnswer.toAnswer(user: currentUser, question: question)
                    
                    // Vérifier si déjà présent
                    if !uniqueAnswers.contains(where: { $0.id == answerModel.id }) {
                        uniqueAnswers.append(answerModel)
                    }
                }
            }
            
            // On met à jour le tableau final
            self.userAnswers = uniqueAnswers
            
            print("L'utilisateur a \(userAnswers.count) réponses")
            
        } catch {
            print("Erreur fetchAnswer : \(error.localizedDescription)")
        }
    }

}


