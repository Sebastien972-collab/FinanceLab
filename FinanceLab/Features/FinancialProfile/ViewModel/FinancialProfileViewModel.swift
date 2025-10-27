//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//
import Observation

@Observable
class FinancialProfileViewModel {
    var questions: [Question] = Question.questionDatabase
    var userAnswers: [Answer] = []
    
    var currentQuestionIndex: Int = 0
    var textAnswer: String = ""
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    // Sauvegarde la réponse de l’utilisateur
    func saveAnswer() {
        guard !textAnswer.isEmpty else { return }
        let answer = Answer(
            content: textAnswer,
            user: .guest,   // TODO: replace with current user
            question: currentQuestion,
        )
        userAnswers.append(answer)
        guard currentQuestionIndex < questions.count - 1 else { return }
        nextQuestion()
    }
    
    // Passe à la question suivante
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            textAnswer.removeAll()
        }
    }
}
