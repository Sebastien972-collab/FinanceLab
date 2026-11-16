//
//  FinancialProfileViewModel.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//  Refactored by Codex on 20/03/2026.
//

import Foundation

enum FinancialQuestionFlowMode {
    case onboarding
    case completion
}

@MainActor
@Observable
final class FinancialProfileViewModel {
    
    // MARK: - Dependencies
    private let service: QuestionsService = .shared
    private let answerService: AnswersService = .shared
    private let userManager: CustomerManager = .shared
    private let draftStore: QuestionnaireDraftStore = .shared
    
    // MARK: - Data State
    var questionsList: [Question] = []
    var userAnswers: [Answer] = []
    var selectedQuestionGroup: QuestionGroup = .essential
    var flowMode: FinancialQuestionFlowMode = .onboarding
    
    // MARK: - UI State
    var textAnswer: String = ""
    var isWorking: Bool = false
    
    // MARK: - Error Handling
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // Callback de fin de flow
    var action: (() -> Void)? = nil
    
    // MARK: - Computed Properties
    var currentQuestion: Question? {
        questionsList.first
    }
    
    var progressLabel: String {
        guard let group = currentQuestion?.questionGroup else { return "" }
        let totalQuestions = Question.questionDatabase.filter { $0.questionGroup == group }.count
        let answeredInGroup = max(0, totalQuestions - questionsList.count)
        return "\(answeredInGroup + (currentQuestion == nil ? 0 : 1)) / \(max(totalQuestions, 1))"
    }

    // MARK: - Flow
    
    func fetchQuestions() async {
        isWorking = true
        defer { isWorking = false }
        
        do {
            if userManager.isLoggedIn {
                try await userManager.fetchProfile()
                userAnswers = userManager.currentUser.answers
            }

            switch flowMode {
            case .onboarding:
                try await loadOnboardingQuestions()
            case .completion:
                try await loadCompletionQuestions()
            }
            
            syncTextAnswerWithCurrentQuestion()
        } catch {
            handleError(error)
        }
    }
    
    func saveAnswer(onComplete: (() -> Void)? = nil) async {
        guard let currentQuestion else { return }
        
        do {
            let normalizedAnswer = try normalize(textAnswer, for: currentQuestion)
            isWorking = true
            defer { isWorking = false }

            let answer = Answer(
                id: currentQuestion.id,
                content: normalizedAnswer,
                user: userManager.currentUser,
                question: currentQuestion
            )

            draftStore.upsert(question: currentQuestion, content: normalizedAnswer)

            if userManager.isLoggedIn {
                userAnswers = try await answerService.upsertAnswer(answer)
                userManager.currentUser.answers = userAnswers
            } else {
                upsertLocalAnswer(answer)
            }

            if !questionsList.isEmpty {
                questionsList.removeFirst()
            }

            syncTextAnswerWithCurrentQuestion()

            if questionsList.isEmpty {
                await finalizeProfile(onComplete: onComplete)
            }
        } catch {
            handleError(error)
        }
    }

    // MARK: - Internal Logic

    private func loadOnboardingQuestions() async throws {
        selectedQuestionGroup = .essential
        let groupQuestions = try await service.getQuestionByGroup(.essential)
        questionsList = groupQuestions.filter { !draftStore.hasAnswer(for: $0) }
        
        if questionsList.isEmpty {
            await finalizeProfile(onComplete: nil)
        }
    }
    
    private func loadCompletionQuestions() async throws {
        let answeredIDs = Set(userAnswers.map(\.question.id))
        
        if let nextGroup = QuestionGroup.completionOrder.first(where: { group in
            Question.questionDatabase.contains {
                $0.questionGroup == group && !answeredIDs.contains($0.id)
            }
        }) {
            selectedQuestionGroup = nextGroup
            let groupQuestions = try await service.getQuestionByGroup(nextGroup)
            questionsList = groupQuestions.filter { !answeredIDs.contains($0.id) }
        } else {
            questionsList = []
            action?()
        }
    }
    
    private func finalizeProfile(onComplete: (() -> Void)?) async {
        let finalAnswers: [Answer]
        
        if userManager.isLoggedIn {
            finalAnswers = userManager.currentUser.answers
        } else {
            finalAnswers = draftStore.buildAnswers(for: userManager.currentUser)
            userManager.currentUser.answers = finalAnswers
        }
        
        let summary = FinancialProfileSummary.from(answers: finalAnswers)
        userManager.currentUser.applyFinancialSummary(summary)
        
        switch flowMode {
        case .onboarding:
            onComplete?()
        case .completion:
            action?()
        }
    }

    private func upsertLocalAnswer(_ answer: Answer) {
        if let index = userAnswers.firstIndex(where: { $0.question.id == answer.question.id }) {
            userAnswers[index] = answer
        } else {
            userAnswers.append(answer)
        }
    }
    
    private func syncTextAnswerWithCurrentQuestion() {
        guard let currentQuestion else {
            textAnswer = ""
            return
        }

        if let savedAnswer = userAnswers.first(where: { $0.question.id == currentQuestion.id }) {
            textAnswer = savedAnswer.content
            return
        }

        textAnswer = draftStore.answer(for: currentQuestion)
    }

    private func normalize(_ value: String, for question: Question) throws -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw LoginError.custom("Réponds à la question pour continuer.")
        }

        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")

        switch question.inputKind {
        case .currency:
            guard let amount = Decimal(string: normalized), amount >= 0 else {
                throw LoginError.custom("Entre un montant valide, par exemple 1200.")
            }
            return NSDecimalNumber(decimal: amount).stringValue
        case .count, .years:
            guard let doubleValue = Double(normalized), doubleValue >= 0 else {
                throw LoginError.custom("Entre un nombre valide supérieur ou égal à zéro.")
            }
            return String(Int(doubleValue.rounded()))
        case .percentage:
            guard let percentage = Decimal(string: normalized), percentage >= 0, percentage <= 100 else {
                throw LoginError.custom("Entre un pourcentage entre 0 et 100.")
            }
            return NSDecimalNumber(decimal: percentage).stringValue
        }
    }
    
    private func handleError(_ error: Error) {
        self.error = error
        self.showError = true
    }
}
