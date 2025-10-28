//
//  ProjectService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 20/10/2025.
//

import Foundation
import FinanceCore

/// Service responsable des opérations réseau liées aux projets (CRUD).
/// Utilise un token stocké en trousseau pour authentifier les requêtes.
class ProjectService {
    /// Instance singleton du service.
    static let shared = ProjectService()
    /// Initialisation privée pour forcer l'utilisation du singleton.
    private init() {}
    /// Service d'accès au trousseau pour récupérer le token d'authentification.
    private let keychain: KeychainService = .shared
    /// Service réseau injecté (par défaut le singleton), rend le test possible en le remplaçant.
    var service: NetworkingService = .shared
    /// Chemin d'endpoint de base pour les ressources projets.
    let endpoint = "projects"

    /// Récupère la liste des projets de l'utilisateur.
    /// - Returns: Un tableau de `Project` mappés depuis `ProjectData`.
    /// - Throws: Une erreur réseau ou d'authentification si le token est manquant/invalid.
    @discardableResult
    func fetProjects() async throws -> [Project] {
        // Récupération du token d'authentification.
        let token = try keychain.getToken()
        // Construction de la requête GET vers l'endpoint projets.
        let apiResquest = APIRequest(endpoint: "projects", httpMethod: .GET)
        // Exécution de l'appel réseau et décodage de la réponse.
        let response = try await service.request(apiResquest, responseType: [ProjectData].self, token: token)
        return response.map {$0.toProject()}
    }
    
    /// Crée un nouveau projet côté serveur.
    /// - Parameter project: Le `ProjectData` à envoyer.
    /// - Returns: Le `ProjectData` renvoyé par l'API (peut contenir des champs calculés côté serveur).
    /// - Throws: Une erreur d'encodage ou réseau.
    func addProject(project: ProjectData) async throws -> ProjectData {
        // Prépare l'encodeur JSON avec la stratégie de dates attendue par l'API.
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(project)
        // Récupère le token depuis le trousseau.
        let token = try keychain.getToken()
        // Construit la requête POST pour créer le projet.
        let apiResquest = APIRequest(endpoint: endpoint, httpMethod: .POST, body: data)
        // Envoie la requête et récupère la réponse typée.
        let response = try await service.request(apiResquest, responseType: ProjectData.self, token: token)
        return response
    }
    
    /// Met à jour un projet existant.
    /// - Parameter project: Le projet à mettre à jour (doit contenir un identifiant).
    /// - Returns: Le `Project` mis à jour.
    /// - Throws: Une erreur d'encodage ou réseau.
    func updatePrject(project: ProjectData) async throws -> Project {
        let token = try keychain.getToken()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(project)
        let apiResquest = APIRequest(endpoint: endpoint + "projects/\(project.id)" , httpMethod: .PUT, body: data)
        return try await service.request(apiResquest, responseType: ProjectData.self, token: token).toProject()
    }
    
    /// Supprime un projet.
    /// - Parameter projectID: Identifiant du projet à supprimer.
    /// - Throws: Une erreur réseau si la suppression échoue.
    func removeProject(projectID: String) async throws {
        // Récupère le token d'authentification.
        let token = try keychain.getToken()
        // Construit la requête DELETE pour l'ID fourni.
        let apiResquest = APIRequest(endpoint: "projects/\(projectID)", httpMethod: .DELETE)
        // Exécute la requête; la réponse peut être vide (204).
        _ = try await service.request(apiResquest, responseType: EmptyResponse.self, token: token)
    }
    
    // MARK: - Remarques
    // - Les méthodes utilisent `ProjectData` (DTO) pour la communication réseau et mappent vers `Project` pour le domaine.
    // - Injectez un `NetworkingService` de test dans `service` pour les tests unitaires.
}
