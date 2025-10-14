//
//  GlossaireView.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

struct GlossaireView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InfoViewModel.self) var infoVM

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Glossaire")
                        .font(.title)
                        .foregroundStyle(Color.Text.contrasted)
                    VStack (alignment: .leading, spacing: 16){
                        ForEach(infoVM.getGlossaire()) { glo in
                            StandardCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(glo.title).font(.cardTitle)
                                        .foregroundStyle(Color.Text.secondary)
                                    Text(glo.description).font(.body)
                                        .foregroundStyle(Color.Text.primary)
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        dismiss()
                    }
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .background {
                FinancialBackground()
                    .ignoresSafeArea(.all)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    GlossaireView()
}
