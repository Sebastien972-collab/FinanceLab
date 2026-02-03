//
//  ProjectService.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 20/10/2025.
//  Refactored for Firestore by Gemini 2026
//

import Foundation
import FinanceCore
import FirebaseFirestore
import FirebaseAuth

/// Service responsable des opérations Firestore liées aux projets (CRUD).
/// Structure de données : users/{userId}/projects/{projectId}
final class ProjectService {
    
    /// Instance singleton du service.
    static let shared = ProjectService()
    /// Initialisation privée pour forcer l'utilisation du singleton.
    private init() {}
    
    // MARK: - Helpers
    
    /// Récupère l'ID de l'utilisateur connecté ou renvoie une erreur.
    private var currentUserId: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Utilisateur non connecté"])
            }
            return uid
        }
    }
    
    // MARK: - CRUD
    
    /// Récupère la liste des projets de l'utilisateur connecté.
    /// - Returns: Un tableau de `Project`.
    func fetchProjects() async throws -> [Project] {
        let uid = try currentUserId
        
        let snapshot = try await DatabaseManager.shared.db.collection("users").document(uid)
            .collection("projects")
            .order(by: "endDate", descending: false) // Exemple de tri par date
            .getDocuments()
        
        // Mapping sécurisé : ProjectData (DTO) -> Project (Domain)
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: ProjectData.self).toProject()
        }
    }
    
    /// Crée un nouveau projet dans Firestore.
    /// - Parameter project: Le `ProjectData` à sauvegarder.
    /// - Returns: Le `ProjectData` mis à jour avec l'ID généré par Firestore.
    func addProject(project: ProjectData) async throws -> ProjectData {
        let uid = try currentUserId
        
        let docRef = DatabaseManager.shared.db.collection("users").document(uid)
            .collection("projects").document(project.id.uuidString)
        
        try docRef.setData(from: project)
        
        return project
    }
    
    /// Met à jour un projet existant.
    /// - Parameter project: Le `ProjectData` contenant les modifications.
    /// - Returns: Le `Project` mis à jour (pour mise à jour locale).
    func updateProject(project: ProjectData) async throws -> ProjectData {
        let uid = try currentUserId
        
        let docRef = DatabaseManager.shared.db.collection("users").document(uid)
            .collection("projects").document(project.id.uuidString)
        
        // setData avec merge: true permet de ne mettre à jour que les champs modifiés
        // ou d'écraser proprement si on passe tout l'objet.
        try docRef.setData(from: project, merge: true)
        
        return project
    }
    
    /// Supprime un projet.
    /// - Parameter projectID: Identifiant du projet à supprimer.
    func removeProject(projectID: String) async throws {
        let uid = try currentUserId
        
        let docRef = DatabaseManager.shared.db.collection("users").document(uid)
            .collection("projects").document(projectID)
        
        try await docRef.delete()
    }
}
