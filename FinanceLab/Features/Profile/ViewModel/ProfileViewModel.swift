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
            let questions = try await QuestionsService.shared.fetchQuestion()
            let answerDatas = try await AnswersService.shared.fetchAnswer()
            for answer in answerDatas {
                if let question = questions.filter({ $0.id == answer.id }).first {
                    currentUser.answers.append(answer.toAnswer(user: currentUser, question: question))
                }
            }
        } catch  {
            
        }

    }
}


