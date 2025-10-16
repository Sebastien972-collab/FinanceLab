//
//  CategoryIconsProfil.swift
//  FinanceLab
//
//  Created by Dembo on 16/10/2025.
//

import Foundation
import SwiftUI


enum CategoryIconsProfil: String, CaseIterable, Identifiable {
    case userFill
    case bagSimpleFill
    case currencyDollardFill
    case houseLineFill
    case shieldSlashFill
    case targetFill
    case warningFill

    var id: String { rawValue }

    var resource: ImageResource {
        switch self {
        case .userFill : return .userFill
        case .bagSimpleFill: return .bagSimpleFill
        case .currencyDollardFill: return .currencyEurFill
        case .houseLineFill: return .houseLineFill
        case .shieldSlashFill: return .shieldSlashFill
        case .targetFill: return .targetFill
        case .warningFill: return .warningFill
        
            
        

        }
    }
    
    var image: Image { Image(resource) }

    
}

#Preview {
    ScrollView {
        ForEach(CategoryIconsProfil.allCases, id: \.self) { icon in
            icon.image
        }
        .padding()
        .padding(.horizontal, 200)
    }


}
