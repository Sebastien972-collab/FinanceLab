//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//

//import Foundation
//
//@Observable
//class FinancialProfileViewModel {
//    private(set) var questions: [Question] = Question.questionDatabase
//    var currentIndex: Int = 0
//    var userAnswers: [UUID: String] = [:]
//    
//    var currentQuestion: Question {
//        questions[currentIndex]
//    }
//    
//    func nextQuestion() {
//        if currentIndex < questions.count - 1 {
//            currentIndex += 1
//        }
//    }
//    
//    func previousQuestion() {
//        if currentIndex > 0 {
//            currentIndex -= 1
//        }
//    }
//    
//    func saveAnswer(_ answer: String) {
//        userAnswers[currentQuestion.id] = answer
//    }
//}


import SwiftUI
import Observation

@Observable
final class FinancialProfileViewModel {
    var allQuestions: [Question] = []
    var groupedQuestions: [QuestionGroup: [Question]] = [:]
    var selectedGroup: QuestionGroup?
    var currentQuestionIndex: Int = 0
    var answers: [UUID: String] = [:] // id question → réponse
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        allQuestions = Question.questionDatabase
        groupedQuestions = Dictionary(grouping: allQuestions, by: { $0.questionGroup })
        selectedGroup = QuestionGroup.allCases.first
    }
    
    var currentQuestions: [Question] {
        guard let selectedGroup else { return [] }
        return groupedQuestions[selectedGroup] ?? []
    }
    
    var currentQuestion: Question? {
        guard currentQuestions.indices.contains(currentQuestionIndex) else { return nil }
        return currentQuestions[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == (currentQuestions.count - 1)
    }
    
    func nextQuestion() {
        if !isLastQuestion { currentQuestionIndex += 1 }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 { currentQuestionIndex -= 1 }
    }
    
    func saveAnswer(_ text: String, for question: Question) {
        answers[question.id] = text
    }
}
