//
//  ArticleListView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct ArticleListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InfoViewModel.self) var infoVM
    
    var isTips: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    Text(isTips ? "Toutes les astuces" : "Derniers articles")
                        .font(.title)
                    LazyVStack(spacing: 16) {
                        if isTips {
                            ForEach(infoVM.tips) { article in
                                NavigationLink(destination: SingleArticleView(article: article).environment(infoVM)) {
                                    StandardCard {
                                        Text(article.title)
                                            .font(.cardTitle)
                                            .foregroundStyle(.primary)
                                            .padding()
                                    }
                                }
                            }
                        } else {
                            ForEach(infoVM.latestArticles) { article in
                                NavigationLink(destination: SingleArticleView(article: article).environment(infoVM)) {
                                    InfoCarouselCard(article: article, isInfiniteWidth: true)
                                }
                            }
                        }
                    }
                }
                .padding()
                .foregroundStyle(Color.Text.contrasted)
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
            .navigationBarBackButtonHidden()
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ArticleListView(isTips: true).environment(InfoViewModel())
}
