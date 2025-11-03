//
//  GlossaireView.swift
//  FinanceLab
//
//  Created by YacineBahaka  on 02/10/2025.
//

import SwiftUI

struct DefinitionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InfoViewModel.self) var infoVM

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Définitions")
                        .font(.title)
                        .foregroundStyle(Color.Text.contrasted)
                    VStack (spacing: 16) {
                        ForEach(infoVM.definitions) { def in
                            StandardCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(def.name).font(.cardTitle)
                                        .foregroundStyle(Color.Text.secondary)
                                    Text(def.content).font(.body)
                                        .foregroundStyle(Color.Text.primary)
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding()
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
            .task {
                await infoVM.getDefinitions()
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    DefinitionView().environment(InfoViewModel())
}
