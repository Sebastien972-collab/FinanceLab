//
//  CategoryIcons.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

enum CategoryIcon: String, CaseIterable, Identifiable {
    case firstAidKitFill
    case ambulanceFill
    case lifebuoyFill
    case tipiFill
    case airplaneTiltFill
    case islandFill
    case armchairFill
    case babyCarriageFill
    case shoppingCartSimpleFill
    case carrotFill
    case catFill
    case carFill
    case gasPumpFill
    case buildingOfficeFill
    case currencyEurFill
    case basketballFill
    case booksFill
    case discFill
    case sneakerFill
    case tShirtFill
    case dressFill
    case forkKnifeFill
    case cheersFill
    case cigaretteFill
    case guitarFill
    case gameControllerFill
    case cakeFill
    case selectionFill

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
        }
    }
    
    var image: Image { Image(resource) }
    func getIconWith(_ string: String) -> CategoryIcon {
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
