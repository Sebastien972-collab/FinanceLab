//
//  CategoryIcons.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

enum CategoryIcon: String, CaseIterable, Identifiable {
    
    // Symboles généralistes et bancaires
    case selectionFill
    case currencyEurFill
    case bankFill
    case handCoinsFill
    case walletFill
    
    // Courses et achats du quotidien
    case shoppingCartSimpleFill
    case carrotFill
    case tShirtFill
    case sneakerFill
    case dressFill
    case armchairFill
    
    // Immobilier
    case buildingOfficeFill
    case houseLineFill
    
    // Transports
    case carFill
    case gasPumpFill
    case trainFill
    case bicycleFill
    
    // Travail
    case bagFill
    case laptopFill
    
    // Famille
    case userFill
    case usersFourFill
    case studentFill
    case babyCarriageFill
    case catFill
    
    // Loisirs
    case monitorPlayFill
    case ticketFill
    case booksFill
    case discFill
    case guitarFill
    case gameControllerFill
    case basketballFill
    
    // Fêtes et sorties
    case cakeFill
    case forkKnifeFill
    case cheersFill

    // Vacances
    case airplaneTiltFill
    case tipiFill
    case islandFill
    
    // Santé et imprévus
    case firstAidKitFill
    case ambulanceFill
    case wheelchairFill
    case lifebuoyFill
    
    // Autres, inclassables
    case cigaretteFill
    case targetFill
    case shieldSlashFill

    var id: String { rawValue }

    var resource: ImageResource {
        switch self {
        case .firstAidKitFill: return .firstAidKitFill
        case .ambulanceFill: return .ambulanceFill
        case .lifebuoyFill: return .lifebuoyFill
        case .tipiFill: return .tipiFill
        case .airplaneTiltFill: return .airplaneTiltFill
        case .islandFill: return .islandFill
        case .armchairFill: return .armchairFill
        case .babyCarriageFill: return .babyCarriageFill
        case .shoppingCartSimpleFill: return .shoppingCartSimpleFill
        case .carrotFill: return .carrotFill
        case .catFill: return .catFill
        case .carFill: return .carFill
        case .gasPumpFill: return .gasPumpFill
        case .buildingOfficeFill: return .buildingOfficeFill
        case .currencyEurFill: return .currencyEurFill
        case .basketballFill: return .basketballFill
        case .booksFill: return .booksFill
        case .discFill: return .discFill
        case .sneakerFill: return .sneakerFill
        case .tShirtFill: return .tShirtFill
        case .dressFill: return .dressFill
        case .forkKnifeFill: return .forkKnifeFill
        case .cheersFill: return .cheersFill
        case .cigaretteFill: return .cigaretteFill
        case .guitarFill: return .guitarFill
        case .gameControllerFill: return .gameControllerFill
        case .cakeFill: return .cakeFill
        case .selectionFill: return .selectionFill
        case .userFill: return .userFill
        case .houseLineFill: return .houseLineFill
        case .targetFill: return .targetFill
        case .shieldSlashFill: return .shieldSlashFill
        case .handCoinsFill : return .handCoinsFill
        case .studentFill : return .studentFill
        case .walletFill : return .walletFill
        case .wheelchairFill : return .wheelchairFill
        case .usersFourFill : return .usersFourFill
        case .bankFill : return .bankFill
        case .monitorPlayFill : return .monitorPlayFill
        case .ticketFill : return .ticketFill
        case .laptopFill : return .laptopFill
        case .trainFill : return .trainFill
        case .bicycleFill : return .bicycleFill
        case .bagFill : return .bagFill
        }
    }
    
    var image: Image { Image(resource) }
    
    // MARK: - Noms des catégories
    var name: String {
        switch self {
        // Symboles généralistes
        case .selectionFill: return "Divers"
        case .currencyEurFill: return "Espèces"
        case .bankFill: return "Frais bancaires"
        case .handCoinsFill: return "Prêt / Remboursement"
        case .walletFill: return "Virement / Salaire"
            
        // Courses
        case .shoppingCartSimpleFill: return "Courses"
        case .carrotFill: return "Alimentation"
        case .tShirtFill: return "Vêtements"
        case .sneakerFill: return "Chaussures"
        case .dressFill: return "Mode"
        case .armchairFill: return "Maison & Déco"
            
        // Immobilier
        case .buildingOfficeFill: return "Loyer / Charges"
        case .houseLineFill: return "Logement"
            
        // Transports
        case .carFill: return "Auto"
        case .gasPumpFill: return "Carburant"
        case .trainFill: return "Transports"
        case .bicycleFill: return "Mobilité douce"
            
        // Travail
        case .bagFill: return "Vie pro"
        case .laptopFill: return "High-Tech"
            
        // Famille
        case .userFill: return "Personnel"
        case .usersFourFill: return "Famille"
        case .studentFill: return "Scolarité"
        case .babyCarriageFill: return "Enfants"
        case .catFill: return "Animaux"
            
        // Loisirs
        case .monitorPlayFill: return "Streaming / TV"
        case .ticketFill: return "Sorties culturelles"
        case .booksFill: return "Livres"
        case .discFill: return "Musique"
        case .guitarFill: return "Hobbies"
        case .gameControllerFill: return "Jeux vidéo"
        case .basketballFill: return "Sport"
            
        // Fêtes
        case .cakeFill: return "Cadeaux"
        case .forkKnifeFill: return "Restaurant"
        case .cheersFill: return "Bar & Soirées"
            
        // Vacances
        case .airplaneTiltFill: return "Voyages"
        case .tipiFill: return "Camping / Nature"
        case .islandFill: return "Vacances"
            
        // Santé
        case .firstAidKitFill: return "Pharmacie"
        case .ambulanceFill: return "Santé"
        case .wheelchairFill: return "Soins spécifiques"
        case .lifebuoyFill: return "Assurances"
            
        // Autres
        case .cigaretteFill: return "Tabac"
        case .targetFill: return "Épargne / Objectif"
        case .shieldSlashFill: return "Imprévus"
        }
    }
    
    static func getIconWith(_ string: String) -> CategoryIcon {
        CategoryIcon(rawValue: string) ?? .selectionFill
    }
}

#Preview {
    ScrollView {
        ForEach(CategoryIcon.allCases, id: \.self) { icon in
            icon.image
        }
        .padding()
        .padding(.horizontal, 200)
    }
}
