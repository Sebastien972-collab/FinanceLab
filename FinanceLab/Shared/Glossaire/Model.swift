//
//  Model.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

class Glossaire: Identifiable {
    var id = UUID()
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

var glossaires: [Glossaire] = [
    Glossaire(title: "Action", description: "Titre qui représente une petite part de propriété d'une entreprise. En acheter, c'est devenir 'co-propriétaire' et espérer profiter des bénéfices si l'entreprise se porte bien."),
    Glossaire(title: "Actif", description: "Tout ce qui a de la valeur et qui peut appartenir à une personne (argent, maison, voiture placements financiers). Les actifs peuvent générer des revenus ou prendre de la valeur avec le temps"),
    Glossaire(title: "Assurance", description: "Contrat qui protège financièrement contre certains risques (maladie, accident, vol, incendie). En échange d'une cotisation régulière, l'assureur couvre tout ou une partie des pertes éventuelles"),
    Glossaire(title: "Budget", description: "Outil de gestion permettant de comparer ses revenus et ses dépenses. Il sert à savoir combien on peut épargner, investir ou consommer sans dépasser ses moyens")
]

