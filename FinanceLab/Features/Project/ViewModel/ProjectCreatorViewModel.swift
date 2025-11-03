//
//  ProjectCreatorManager.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//

import Foundation
import FinanceCore

/// Gestionnaire/ViewModel responsable de la création et de l'édition d'un projet.
/// - Rassemble l'état du formulaire (nom, dates, icône, montant objectif) et la logique de validation.
/// - Interagit avec `ProjectService` pour persister les données.
/// - Utilisé par l'UI pour afficher/mettre à jour les champs et réagir aux erreurs.
@Observable
class ProjectCreatorViewModel {
    /// Nom du projet saisi par l'utilisateur.
    var name: String = ""
    /// Date de début du projet (non utilisée dans la validation actuelle).
    var startedDate: Date = .now
    /// Date de fin ciblée pour atteindre l'objectif.
    var finalDate: Date =  .now
    /// Nom interne de l'image/ressource associée (déprécié si `selectedIcon` est utilisé).
    var imageName: String = ""
    /// Montant objectif saisi sous forme de chaîne (sera converti en Decimal).
    var stringGoalAmount: String = ""
    /// Dernière erreur rencontrée (par défaut: champs vides).
    var error: Error = ProjectCreatorError.emptyFiels
    /// Indique si une alerte/feuille d'erreur doit être affichée.
    var showError: Bool = false
    /// Montant objectif converti depuis `stringGoalAmount`. Conversion tolérante (entier si possible, sinon 0).
    var goalAmount: Decimal {
        convertStringToDecimal()
    }
    /// Représentation localisée (fr_FR) de `finalDate` pour l'affichage.
    var finalDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: finalDate)
    }
    /// Contrôle l'état d'édition du formulaire.
    var isEditing: Bool = false
    /// ViewModel global des projets (dépendance locale).
    var manager: ProjectViewModel = .init()
    /// Icône choisie pour représenter le projet.
    var selectedIcon: CategoryIcon = .carFill
    /// Indique si l'on modifie un projet existant (update) plutôt que d'en créer un.
    var isUpdate = false
    
    
    /// Service de persistance des projets (singleton).
    let service: ProjectService = .shared
    /// Déclenche une revalidation (hook potentiel pour recalculs externes).
    /// - Parameter asc: valeur non utilisée actuellement (placeholder).
    func recalculator(_ asc : Decimal) {
        check()
    }
    /// Valide le formulaire et tente de créer un nouveau projet.
    /// - Effectue une vérification minimale (champs requis),
    /// - Construit un `Project`, met à jour son icône, puis appelle `ProjectService.addProject`.
    /// - En cas de succès, sort du mode édition; en cas d'échec, expose l'erreur via `showError`.
    func validate() async {
        check()
        do {
            // Construction du modèle métier à partir des champs du formulaire
            let newProject = Project(name: name, iconName: imageName, finalDate: finalDate, amount: goalAmount)
            // Synchronisation de l'icône choisie (priorité à selectedIcon)
            newProject.updateIcon(selectedIcon.rawValue)
            // Persistance via le service (asynchrone)
            _ = try await service.addProject(project: newProject.toProjectData())
            // Sortie du mode édition après succès
            self.isEditing = false
        } catch  {
            // Affiche l'erreur à l'UI
            showError(error)
        }
    }
    /// Réinitialise les champs du formulaire.
    /// - Parameter after: callback optionnel exécuté après la réinitialisation.
    func reset(_ after: (() -> Void)? = nil) {
        // Efface le nom
        name.removeAll()
        // Efface le nom d'image
        imageName.removeAll()
        // Efface le montant saisi
        stringGoalAmount.removeAll()
        // Désactive le mode édition
        self.isEditing = false
        // Callback post-réinitialisation
        after?()
        
        
    }
    /// Met à jour un projet existant via le service et renvoie le projet mis à jour.
    func update(project: Project) async throws -> Project {
        try await service.updatePrject(project: project.toProjectData())
    }
    
    /// Met à jour l'état d'erreur et déclenche son affichage.
    func showError(_ error: Error) {
        self.error = error
        self.showError = true
    }
    
    /// Vérifie les champs requis du formulaire.
    /// - Actuellement: s'assure que `name` et `stringGoalAmount` ne sont pas vides.
    /// - En cas d'échec: positionne `error` et `showError`.
     func check()  {
        // Validation minimale des champs requis
        guard !name.isEmpty, !stringGoalAmount.isEmpty else {
            self.error = ProjectCreatorError.emptyFiels
            self.showError = true
            return
        }
    }
    /// Convertit `stringGoalAmount` en `Decimal`.
    /// - Retourne 0 si la chaîne est vide ou invalide.
    /// - Tente d'abord une conversion `Decimal(string:)`, puis une conversion entière de secours.
    private func convertStringToDecimal() -> Decimal {
        // Chaîne vide -> 0
        guard !stringGoalAmount.isEmpty else { return 0 }
        // Tentative principale de conversion en Decimal
        guard let decimal = Decimal(string: stringGoalAmount) else {
            // Fallback: conversion en entier si possible
            if let intValue = Int(stringGoalAmount) {
                return Decimal(intValue)
            }
            // Conversion impossible -> 0
            return 0
        }
        return decimal
    }
    
}

