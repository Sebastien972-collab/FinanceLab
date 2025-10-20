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
    var answerChoices: [AnswerChoice] = Answer.answerChoiceDatabase
    var userAnswers: [Answer] = []
    
    var currentQuestionIndex: Int = 0
    var textAnswer: String = ""
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    // Récupère les choix possibles pour la question courante
    var currentChoices: [AnswerChoice] {
        answerChoices.filter { $0.questionId == currentQuestion.id }
    }

    //Sauvegarde la réponse de l’utilisateur
    func saveAnswer(_ content: String, for question: Question) {
        let answer = Answer(
            content: content,
            userId: UUID(),
            questionId: question.id,
            answerCategory: question.questionGroup.toAnswerCategory()
        )
        userAnswers.append(answer)
    }

    // Passe à la question suivante
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            textAnswer = ""
        }
    }

    // Permet de lier QuestionGroup → AnswerCategory
    // (utile pour ton modèle Answer)
    func questionGroupToCategory(_ group: QuestionGroup) -> AnswerCategory {
        switch group {
        case .personal: return .personal
        case .professional: return .professional
        case .patrimony: return .patrimony
        case .financial: return .financial
        case .objectives: return .objectives
        case .risk: return .risk
        case .protection: return .protection
        }
    }
}

extension QuestionGroup {
    func toAnswerCategory() -> AnswerCategory {
        switch self {
        case .personal: return .personal
        case .professional: return .professional
        case .patrimony: return .patrimony
        case .financial: return .financial
        case .objectives: return .objectives
        case .risk: return .risk
        case .protection: return .protection
        }
    }
}
