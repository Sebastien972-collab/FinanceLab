//
//  GlossaireView.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

struct GlossaireView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Glossaire")
                .padding(.horizontal, 25)
                .padding(.top, 20)
                .font(.title)
                .foregroundStyle(Color.Text.contrasted)
            
            List(glossaires) { glo in
                StandardCard {
                    VStack (alignment: .leading, spacing: 16){
                        Text(glo.title).font(.cardTitle)
                        Text(glo.description).font(.body)
                    }.foregroundStyle(.white)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .padding(.top, -20)
        }
        .background {
            FinancialBackground()
                .ignoresSafeArea(.all)
        }
        
    }
}

#Preview {
    GlossaireView()
}
