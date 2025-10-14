//
//  SingleArticleView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct SingleArticleView: View {
    @Environment(\.dismiss) private var dismiss
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
                    ProgressView()
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text(article.title)
                        .font(.title)
                    ForEach(article.content, id:\.self) { content in
                        switch content {
                            case .paragraph(let text):
                                Text(LocalizedStringKey(text))
                                    .font(.body)
                            case .subtitle(let text):
                                Text(LocalizedStringKey(text))
                                    .font(.title2)
                                    .padding(.top, 8)
                            case .image(let url, let caption):
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                if let caption = caption {
                                    Text(LocalizedStringKey(caption))
                                        .font(.caption)
                                }
                            case .list(let items) :
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(items, id: \.self) { item in
                                        HStack {
                                            Text("•")
                                            Text(LocalizedStringKey(item))
                                        }
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
            .background {
                FinancialBackground().ignoresSafeArea()
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    SingleArticleView(article:
        Article(
            title: "L’éducation financière : une clé pour mieux gérer son argent à tout moment",
            category: .article,
            image: "https://www.csusb.edu/sites/default/files/financial-literacy%20image_1.jpg",
            content: [
                .paragraph("Dans un monde où les décisions économiques influencent chaque aspect de notre vie, comprendre les bases de la gestion financière n’est plus un luxe, mais une nécessité. Pourtant, beaucoup d’adultes avouent ne pas maîtriser des notions simples comme l’épargne, l’investissement ou le crédit."),
                .subtitle("Pourquoi l’éducation financière est-elle essentielle ?"),
                .paragraph("L’éducation financière aide à prendre des décisions éclairées. Elle permet de comprendre comment fonctionne l’argent, comment établir un budget, éviter le surendettement et préparer l’avenir. Mieux informé, chacun devient acteur de sa propre stabilité financière."),
                .image(
                    url: "https://example.com/education-financiere.jpg",
                    caption: "Apprendre à gérer son argent, un investissement durable."
                ),
                .subtitle("Les notions de base à connaître"),
                .list(items: [
                    "Établir un budget mensuel et suivre ses dépenses.",
                    "Constituer une épargne de précaution pour les imprévus.",
                    "Comprendre le fonctionnement des crédits et des taux d’intérêt.",
                    "Différencier épargne, placement et investissement.",
                    "Anticiper la retraite et la fiscalité."
                ]),
                .subtitle("Comment améliorer sa culture financière ?"),
                .paragraph("Il existe aujourd’hui de nombreux outils accessibles : applications de gestion budgétaire, podcasts spécialisés, formations en ligne ou encore simulateurs bancaires. Commencer par analyser ses habitudes de consommation est souvent la première étape vers une meilleure maîtrise de son argent."),
                .subtitle("En conclusion"),
                .paragraph("Développer sa culture financière, c’est investir dans sa liberté. Plus on comprend les mécanismes économiques, plus on peut faire des choix adaptés à ses besoins, ses projets et ses valeurs. C’est un apprentissage continu, mais chaque pas compte vers une vie plus sereine et équilibrée.")
            ],
        )
    )
}
