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
}


