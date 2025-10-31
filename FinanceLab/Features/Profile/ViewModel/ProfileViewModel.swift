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
        // Exemples de réponses à afficher dans le profil
        userAnswers = [
            Answer(
                content: "1300",
                user: currentUser,
                question: Question.questionDatabase[0] // "Revenus stables"
            ),
            Answer(
                content: "700",
                user: currentUser,
                question: Question.questionDatabase[3] // "Charges"
            ),
            Answer(
                content: "150",
                user: currentUser,
                question: Question.questionDatabase[4] // "Épargne"
            ),
            Answer(
                content: "2",
                user: currentUser,
                question: Question.questionDatabase[5] // "Enfants"
            )
        ]
    }
}


