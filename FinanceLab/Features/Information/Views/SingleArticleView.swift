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
                AsyncImage(url: URL(string: article.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                } placeholder: {
                    FinancialPlaceholder()
                }
                VStack(alignment: .leading, spacing: 12) {
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
            .task {
                await infoVM.fetchArticleContents(idArticle: article.id)
            }
        }
    }
}

//#Preview {
//    SingleArticleView(article:
//        Article(
//            title: "L’éducation financière : une clé pour mieux gérer son argent à tout moment",
//            image: "https://www.csusb.edu/sites/default/files/financial-literacy%20image_1.jpg",
//            content: [
//                .paragraph("Dans un monde où les décisions économiques influencent chaque aspect de notre vie, comprendre les bases de la gestion financière n’est plus un luxe, mais une nécessité. Pourtant, beaucoup d’adultes avouent ne pas maîtriser des notions simples comme l’épargne, l’investissement ou le crédit."),
//                .subtitle("Pourquoi l’éducation financière est-elle essentielle ?"),
//                .paragraph("L’éducation financière aide à prendre des décisions éclairées. Elle permet de comprendre comment fonctionne l’argent, comment établir un budget, éviter le surendettement et préparer l’avenir. Mieux informé, chacun devient acteur de sa propre stabilité financière."),
//                .image(
//                    url: "https://example.com/education-financiere.jpg",
//                    caption: "Apprendre à gérer son argent, un investissement durable."
//                ),
//                .subtitle("Les notions de base à connaître"),
//                .list(items: [
//                    "Établir un budget mensuel et suivre ses dépenses.",
//                    "Constituer une épargne de précaution pour les imprévus.",
//                    "Comprendre le fonctionnement des crédits et des taux d’intérêt.",
//                    "Différencier épargne, placement et investissement.",
//                    "Anticiper la retraite et la fiscalité."
//                ]),
//                .subtitle("Comment améliorer sa culture financière ?"),
//                .paragraph("Il existe aujourd’hui de nombreux outils accessibles : applications de gestion budgétaire, podcasts spécialisés, formations en ligne ou encore simulateurs bancaires. Commencer par analyser ses habitudes de consommation est souvent la première étape vers une meilleure maîtrise de son argent."),
//                .subtitle("En conclusion"),
//                .paragraph("Développer sa culture financière, c’est investir dans sa liberté. Plus on comprend les mécanismes économiques, plus on peut faire des choix adaptés à ses besoins, ses projets et ses valeurs. C’est un apprentissage continu, mais chaque pas compte vers une vie plus sereine et équilibrée.")
//            ],
//        )
//    )
//}
