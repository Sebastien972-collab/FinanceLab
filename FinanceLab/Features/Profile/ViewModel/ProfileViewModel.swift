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
            for answer in answers {
                if let question = questions.filter({ $0.id == answer.idQuestion }).first {
                    userManager.currentUser.answers.append(answer.toAnswer(user: currentUser, question: question))
                }
            }
            userAnswers = userManager.currentUser.answers
            print("L'utilisateurs à " + userAnswers.count.description + " Réponses ")
        } catch  {
            print(error.localizedDescription)
        }
    }
}


