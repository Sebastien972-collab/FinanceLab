//
//  FinancialProfileViewModel.swift
//  FinanceLab
//
//  Created by Dembo on 15/10/2025.
//  Refactored by Gemini (Architecture Expert) 2026
//

import Foundation
import FinanceCore

@MainActor
@Observable
class FinancialProfileViewModel {
    
    // MARK: - Dependencies
    private let service: QuestionsService = .shared
    private let answerService: AnswersService = .shared
    private let userManager: CustomerManager = .shared
    private let storage: UserStorage = .shared
    
    // MARK: - Data State
    var questionsList: [Question] = []
    var userAnswers: [Answer] = []
    var selectedQuestionGroup: QuestionGroup = .essential
    
    // MARK: - UI State
    var textAnswer: String = ""
    var isWorking: Bool = false // Pilote les spinners et les désactivations boutons
    var isNewQuestion: Bool = false
    
    // MARK: - Error Handling
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    // Callback de fin de flow
    var action: (() -> Void)? = nil
    
    // MARK: - Computed Properties
    var currentQuestion: Question? {
        questionsList.first
    }
    
    // MARK: - Logic Flow
    
    /// Charge les questions, en déterminant intelligemment le groupe si nécessaire
    func fetchQuestions() async {
        isWorking = true
        defer { isWorking = false } // S'exécute toujours à la fin
        
        do {
            if isNewQuestion {
                try await pickNextQuestionGroup()
            }
            // Récupération des questions du groupe sélectionné
            questionsList = try await service.getQuestionByGroup(selectedQuestionGroup)
            
        } catch {
            handleError(error)
        }
    }
    
    /// Sauvegarde la réponse et passe à la suivante
    func saveAnswer(onComplete: (() -> Void)? = nil) async {
        // 1. Validation
        guard let currentQ = currentQuestion else { return }
        guard !textAnswer.isEmpty else {
            handleError(LoginError.emptyFields)
            return
        }
        
        // Validation numérique (puisque c'est un profil financier)
        // On remplace la virgule par un point pour la conversion Double si l'utilisateur a un clavier FR
        let sanitizedText = textAnswer.replacingOccurrences(of: ",", with: ".")
        guard Double(sanitizedText) != nil else {
            handleError(LoginError.custom("Veuillez entrer un montant valide."))
            return
        }

        isWorking = true
        defer { isWorking = false }
        
        // 2. Création de la réponse
        let answer = Answer(content: sanitizedText, user: userManager.currentUser, question: currentQ)
        userAnswers.append(answer)
        
        // 3. Reset UI
        textAnswer = "" // On vide le champ pour la prochaine question
        
        // 4. Passage à la suite
        // On retire la question qu'on vient de traiter
        if !questionsList.isEmpty {
            questionsList.removeFirst()
        }
        
        // 5. Vérification de fin de liste
        if questionsList.isEmpty {
            await finalizeProfile(onComplete: onComplete)
        }
    }
    
    // MARK: - Private Logic
    
    /// Détermine quel groupe de questions l'utilisateur n'a pas encore rempli
    private func pickNextQuestionGroup() async throws {
        let answeredGroups = try await answerService.fetchAllUserAnsweredQuestionGroups()
        
        // Algorithme : On prend le premier groupe de l'enum qui n'est pas dans les groupes déjà répondus
        if let nextGroup = QuestionGroup.allCases.first(where: { !answeredGroups.contains($0) }) {
            selectedQuestionGroup = nextGroup
        } else {
            // Tous les groupes sont faits (cas rare à gérer selon vos règles métier)
            print("All groups answered. Defaulting to essential or handling end of flow.")
        }
    }
    
    /// Calcule le profil financier et sauvegarde les résultats
    private func finalizeProfile(onComplete: (() -> Void)?) async {
        
        // Séparation Revenus / Dépenses via filter
        let revenueAnswers = userAnswers.filter { $0.question.isRevenue }
        let expenseAnswers = userAnswers.filter { $0.question.isCharge }

        // Calcul avec reduce (plus performant et lisible qu'une boucle for)
        let totalRevenue = calculateTotal(from: revenueAnswers)
        let totalExpense = calculateTotal(from: expenseAnswers)

        // Persistance locale
        storage.saveUserString(String(totalRevenue), forKey: .totalRent) // Attention au naming key vs variable
        storage.saveUserString(String(totalExpense), forKey: .totalExpenses)

        // Logique métier du profil
        let profileManager = FinancialProfileManager(
            revenues: Decimal(totalRevenue),
            expenses: Decimal(totalExpense)
        )
        
        // Mise à jour de l'utilisateur en mémoire
        // Note: Idéalement, il faudrait aussi un appel `userManager.save()` ou `answerService.send(userAnswers)` ici
        userManager.currentUser.userCategory = profileManager.profile
        userManager.currentUser.answers = userAnswers
        
        // Exécution des callbacks sur le MainActor
        if isNewQuestion {
            action?()
        } else {
            onComplete?()
        }
    }
    
    private func calculateTotal(from answers: [Answer]) -> Double {
        answers.reduce(0) { partialResult, answer in
            // Conversion sécurisée, on considère 0 si le parsing échoue
            let value = Double(answer.content.replacingOccurrences(of: ",", with: ".")) ?? 0
            return partialResult + value
        }
    }
    
    private func handleError(_ error: Error) {
        self.error = error
        self.showError = true
    }
}
