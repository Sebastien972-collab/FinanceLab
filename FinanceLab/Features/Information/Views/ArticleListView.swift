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
                VStack(spacing: 16) {
                    HStack {
                        Text(isTips ? "Toutes les astuces" : "Derniers articles")
                            .font(.title)
                        Spacer()
                    }
                    LazyVStack(spacing: 16) {
                        if isTips {
                            ForEach(infoVM.getTips()) { article in
                                NavigationLink(destination: SingleArticleView(article: article)) {
                                    StandardCard {
                                        Text(article.title)
                                            .font(.cardTitle)
                                            .foregroundStyle(.primary)
                                            .padding()
                                    }
                                }
                            }
                        } else {
                            ForEach(infoVM.getLatestArticles()) { article in
                                NavigationLink(destination: SingleArticleView(article: article)) {
                                    InfoCarouselCard(article: article, isInfiniteWidth: true)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .foregroundStyle(Color.Text.contrasted)
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
