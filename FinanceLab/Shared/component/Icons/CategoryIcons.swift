//
//  CategoryIcons.swift
//  FinanceLab
//
//  Created by Anne Ferret on 08/10/2025.
//

import SwiftUI

let categoryIcons: [ImageResource] = [
    .firstAidKitFill, .ambulanceFill, .lifebuoyFill, .tipiFill, .airplaneTiltFill, .islandFill, .armchairFill, .babyCarriageFill, .shoppingCartSimpleFill, .carrotFill, .catFill, .carFill, .gasPumpFill, .buildingOfficeFill, .currencyEurFill, .basketballFill, .booksFill, .discFill, .sneakerFill, .tShirtFill, .dressFill, .forkKnifeFill, .cheersFill, .cigaretteFill, .guitarFill, .gameControllerFill, .cakeFill, .selectionFill
]

#Preview {
    ScrollView {
        ForEach(categoryIcons, id: \.self) { icon in
            Image(icon)
        }
        .padding()
        .padding(.horizontal, 200)
    }
}
