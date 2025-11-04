//
//  UserManager.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 14/10/2025.
//

import Foundation

/// Gestionnaire d'état utilisateur (session) côté client.
///
/// - Maintient l'utilisateur courant en mémoire (`currentUser`).
/// - Expose des méthodes de haut niveau pour créer, se connecter, récupérer et mettre à jour le profil.
/// - Délègue les appels réseau à `UserService`.
class UserManager {
    /// Singleton pour un accès global à l'état utilisateur.
    static let shared: UserManager = .init()
    /// Initialisation privée pour imposer le pattern singleton.
    private init () {}
    /// Service en charge des opérations réseau utilisateur.
    private let service: UserService = .shared
    /// Représentation de l'utilisateur courant (invité par défaut).
    private(set) var currentUser: User = .guest
    /// Indique si un utilisateur est connecté (différent de `.guest`).`
    var isLoggedIn: Bool {
        currentUser != .guest
    }
    
    /// Crée un utilisateur puis met à jour `currentUser` avec le profil obtenu.
    func create(firstName: String, lastName: String, email: String, password: String) async throws {
        do {
            let user = try await service.create(firstName: firstName, lastName: lastName, email: email, password: password)
            let answerDatas = try await AnswersService.shared.postAllAnswers(answers: self.currentUser.answers.map { $0.toAnswerData()})
            let questions = try await QuestionsService.shared.fetchQuestion()
            for answer in answerDatas {
                if let question = questions.filter({ $0.id == answer.id }).first {
                    user.answers.append(answer.toAnswer(user: user, question: question))
                }
            }
            self.currentUser = user
            
        } catch  {
            throw error
        }
    }
    
    
    /// Authentifie l'utilisateur puis met à jour `currentUser`.
    func login(email: String, password: String) async throws {
        do {
            self.currentUser = try await service.login(email: email, password: password)
        } catch  {
            throw error
        }
    }
    /// Récupère le profil depuis l'API et met à jour `currentUser`.
    func fetchProfile() async throws {
        self.currentUser =  try await service.fetchProfile()
    }
    /// Met à jour localement l'utilisateur courant (sans appel réseau).
    func upadateUser(_ newUser: User) {
        self.currentUser = newUser
    }
    func updateBalance(of balance: Decimal) async throws {
        self.currentUser.balance = try await Decimal(service.updateBalance(balance: balance.toDoucble()))
    }
    /// Réinitialise l'état utilisateur en le repassant à `.guest`.
    func logout() {
        // Supprimer le token dans le Keychain
        KeychainService.shared.delete(service: "com.financelab.auth", account: "jwtToken")
        // Réinitialiser l’utilisateur actuel
        self.currentUser = .guest // ou un User() vide selon ton modèle
        print("Utilisateur déconnecté")
    }
    
}
