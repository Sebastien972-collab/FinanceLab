//
//  SingleArticleView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct SingleArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InfoViewModel.self) var infoVM
    
    let article: Article
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                AsyncImage(url: URL(string: article.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                } placeholder: {
                    FinancialPlaceholder()
                }
                    VStack {
                        Text(article.title)
                            .font(.title)
                    ForEach(infoVM.articleContent) { content in
                        switch content.type {
                            case .paragraph:
                                Text(content.content)
                                    .font(.body)
                            case .subtitle:
                                Text(content.content)
                                    .font(.title2)
                                    .padding(.top, 8)
                            case .image:
                                AsyncImage(url: URL(string: content.content)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                            case .list:
                                let list = content.content.split(separator: "\\n")
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(list, id:\.self) { item in
                                        Text("• " + item)
                                            .font(.body)
                                    }
                                }
                            }
                        }
                    }
                    .font(.body)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .foregroundStyle(Color.Text.contrasted)
                }
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
            .task {
                await infoVM.fetchArticleContents(idArticle: article.id)
            }
        }
    }
}

#Preview {
    SingleArticleView(article: Article(
        id: UUID(),
        title: "Article",
        image: nil,
        creationDate: nil,
        articleCategory: .article
    )
    ).environment(InfoViewModel())
}
