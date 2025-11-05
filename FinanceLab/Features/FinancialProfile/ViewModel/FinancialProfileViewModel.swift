//
//  File.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//

import Foundation
import FinanceCore
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
    var isNewQuestion: Bool = false
    var currentQuestionIndex: Int = 0
    var textAnswer: String = ""
    var action: (() -> Void)? = nil
    
    //  Gestion des erreurs
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // MARK: - Question actuelle
    var currentQuestion: Question? {
        questionsList.first
    }
    
    var selectedQuestionGroup: QuestionGroup = .essential
    
    func pickQuestionGroup() async {
        var answeredQuestionGroups: [QuestionGroup] = []
        do {
            answeredQuestionGroups = try await answerService.fetchAllUserAnsweredQuestionGroups()
        } catch {
            self.error = error
            showError = true
            print("Error fetching already answered question groups: \(error)")
        }
        for group in QuestionGroup.allCases {
            if !answeredQuestionGroups.contains(group) {
                selectedQuestionGroup = group
                return
            }
        }
    }
    
    // CRUD
    func fetchQuestions() async {
        if isNewQuestion {
            print("Ce sont bien les nouvelles questions !? ")
            await pickQuestionGroup()
        }
        do {
            questionsList = try await service.getQuestionByGroup(selectedQuestionGroup)
        } catch {
            self.error = error
            showError = true
            print("Error fetching questions: \(error)")
        }
    }
    func saveAnswer(callback: (() -> Void)? = nil) async {
        guard !textAnswer.isEmpty, let currentQuestion = currentQuestion else {
            launchError(LoginError.emptyFields)
            return
        }

        let answer = Answer(content: textAnswer, user: userManager.currentUser, question: currentQuestion)
        userAnswers.append(answer)

        // Retirer la question actuelle
        questionsList.remove(at: 0)

        // Si c'était la dernière question
        if questionsList.isEmpty {
            let rent = userAnswers.filter { $0.question.isRevenue }
            let expense = userAnswers.filter { $0.question.isCharge }

            let totalRent = calcul(answers: rent)
            UserStorage.shared.saveUserString(String(totalRent), forKey: .totalRent)

            let totalExpense = calcul(answers: expense)
            UserStorage.shared.saveUserString(String(totalExpense), forKey: .totalExpenses)

            let manager = FinancialProfileManager(
                revenues: Decimal(totalRent),
                expenses: Decimal(totalExpense)
            )
            userManager.currentUser.userCategory = manager.profile
            userManager.currentUser.answers = userAnswers

            if isNewQuestion {
                action?()
            } else {
                callback?()
            }
            return
        }

        // Sinon on continue
    }
    
    func launchError(_ error: Error) {
        self.error = error
        self.showError = true
    }
    func calcul(answers : [Answer]) -> Double {
        var result: Double = 0
        for answer in answers {
            result += Double(answer.content) ?? 0
        }
        return result
    }
}

