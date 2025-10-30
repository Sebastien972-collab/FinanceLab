//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//
import Observation

//@Observable
//class FinancialProfileViewModel {
//    var questions: [Question] = Question.questionDatabase
//    var userAnswers: [Answer] = []
//    
//    var currentQuestionIndex: Int = 0
//    var textAnswer: String = ""
//    
//    var currentQuestion: Question {
//        questions[currentQuestionIndex]
//    }
//    
//    // Sauvegarde la réponse de l’utilisateur
//    func saveAnswer() {
//        guard !textAnswer.isEmpty else { return }
//        let answer = Answer(
//            content: textAnswer,
//            user: .guest,   // TODO: replace with current user
//            question: currentQuestion,
//        )
//        userAnswers.append(answer)
//        guard currentQuestionIndex < questions.count - 1 else { return }
//        nextQuestion()
//    }
//    
//    // Passe à la question suivante
//    func nextQuestion() {
//        if currentQuestionIndex < questions.count - 1 {
//            currentQuestionIndex += 1
//            textAnswer.removeAll()
//        }
//    }
//}

import Foundation
import Observation

@Observable
class FinancialProfileViewModel {
    // Services
    private let service = QuestionsService.shared
    
    // Données
    var questionsList: [Question] = []
    var userAnswers: [Answer] = []
    
    //  État de navigation
    var currentQuestionIndex: Int = 0
    var textAnswer: String = ""
    
    //  Gestion des erreurs
    var error: Error?
    var showError: Bool = false
    
    // MARK: - Question actuelle
    var currentQuestion: Question? {
        guard !questionsList.isEmpty, currentQuestionIndex < questionsList.count else { return nil }
        return questionsList[currentQuestionIndex]
    }
    
    // CRUD
    func fetchQuestions() async {
        do {
            questionsList = try await service.fetchQuestion()
        } catch {
            self.error = error
            showError = true
            print("Error fetching questions: \(error)")
        }
    }
    
    func postQuestion(_ question: Question) async {
        do {
            try await service.postQuestion(question: question.toQuestionData())
            await fetchQuestions()
        } catch {
            self.error = error
            showError = true
            print("Error posting question: \(error)")
        }
    }
    
    func putQuestion(_ question: Question) async {
        do {
            try await service.putQuestion(question: question.toQuestionData())
            await fetchQuestions()
        } catch {
            self.error = error
            showError = true
            print("Error updating question: \(error)")
        }
    }
    
    func deleteQuestion(_ id: UUID) async {
        do {
            try await service.deleteQuestion(id: id)
            await fetchQuestions()
        } catch {
            self.error = error
            showError = true
            print("Error deleting question: \(error)")
        }
    }
    
    // Gestion des réponses utilisateur
    func saveAnswer() {
        guard !textAnswer.isEmpty, let currentQuestion else { return }
        let answer = Answer(
            content: textAnswer,
            user: .guest,
            question: currentQuestion
        )
        userAnswers.append(answer)
        nextQuestion()
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questionsList.count - 1 {
            currentQuestionIndex += 1
            textAnswer.removeAll()
        }
    }
}

