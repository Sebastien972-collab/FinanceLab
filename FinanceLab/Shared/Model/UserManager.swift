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
    /// Indique si un utilisateur est connecté (différent de `.guest`).
    var isLoggedIn: Bool {
        currentUser != .guest
    }
    /// Crée un utilisateur puis met à jour `currentUser` avec le profil obtenu.
    func create(firstName: String, lastName: String, email: String, password: String) async throws {
        do {
            self.currentUser = try await service.create(firstName: firstName, lastName: lastName, email: email, password: password)
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
    /// Réinitialise l'état utilisateur en le repassant à `.guest`.
    func logout() {
        self.currentUser = .guest
    }
}
