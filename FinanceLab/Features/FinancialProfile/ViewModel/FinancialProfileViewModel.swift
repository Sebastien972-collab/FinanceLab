//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//

import Foundation

@Observable
class FinancialProfileViewModel {
    private(set) var questions: [Question] = Question.questionDatabase
    var currentIndex: Int = 0
    var userAnswers: [UUID: String] = [:]
    
    var currentQuestion: Question {
        questions[currentIndex]
    }
    
    func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }
    }
    
    func previousQuestion() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func saveAnswer(_ answer: String) {
        userAnswers[currentQuestion.id] = answer
    }
}
