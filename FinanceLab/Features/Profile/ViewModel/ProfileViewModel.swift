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
    var currentUser: User = .init(firstName: "Sophie", lastName: "DAGUIN", email: "sohphie@gmail.com")
    
    /// Base locale de réponses
//    var userAnswers: [Answer] = Answer.userAnswerDatabase
    var userAnswers: [Answer] = []
    
   
        init() {
            // Exemples de réponses à afficher dans le profil
            userAnswers = [
                Answer(
                    content: "Je suis en CDI et je gagne 1300 € / mois",
                    user: currentUser,
                    question: Question.questionDatabase[0] // "Revenus stables"
                ),
                Answer(
                    content: "700 € de charges fixes",
                    user: currentUser,
                    question: Question.questionDatabase[3] // "Charges"
                ),
                Answer(
                    content: "J’épargne 150 € par mois",
                    user: currentUser,
                    question: Question.questionDatabase[4] // "Épargne"
                ),
                Answer(
                    content: "2 enfants à charge",
                    user: currentUser,
                    question: Question.questionDatabase[5] // "Enfants"
                )
            ]
        }
}


