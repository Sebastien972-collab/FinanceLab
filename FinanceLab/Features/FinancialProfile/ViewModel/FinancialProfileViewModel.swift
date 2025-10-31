//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//

import Foundation

@Observable
class FinancialProfileViewModel {
    // Services
    private let service = QuestionsService.shared
    private let answerService = AnswersService.shared
    private let userManager = UserManager.shared
    // Données
    var questionsList: [Question] = []
    var userAnswers: [Answer] = []
    
    //  État de navigation
    var currentQuestionIndex: Int = 0
    var textAnswer: String = ""
    
    //  Gestion des erreurs
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // MARK: - Question actuelle
    var currentQuestion: Question? {
        questionsList.first
    }
    
    var selectedQuestionGroup: QuestionGroup = .essential
    
    
    // CRUD
    func fetchQuestions() async {
        do {
            questionsList = try await service.getQuestionByGroup(selectedQuestionGroup)
        } catch {
            self.error = error
            showError = true
            print("Error fetching questions: \(error)")
        }
    }
    func saveAnswer(callback: (() -> Void)? = nil) async {
        print("Le nombre de question est \(questionsList.count)")
        guard !textAnswer.isEmpty, let currentQuestion = currentQuestion else {
            launchError(LoginError.emptyFiels)
            return
        }
        let answer = Answer(
            content: textAnswer,
            user: userManager.currentUser,
            question: currentQuestion
        )
        userAnswers.append(answer)
        guard questionsList.count > 1 else {
            userManager.currentUser.asnwer = userAnswers
            if let callback = callback {
                callback()
            }
            return
        }
        questionsList.remove(at: 0)
        
    }
    
    func launchError(_ error: Error) {
        self.error = error
        self.showError = true
    }
}

