//
//  InfoViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

@Observable
class InfoViewModel {
    
    func getCarouselArticles() -> [Article] {
        let art = articles.reversed()
        return Array(art.prefix(4))
    }
    
    private let articles: [Article] = [
        Article(
            title: "L’éducation financière : une clé pour mieux gérer son argent",
            category: .article,
            image: "https://media.licdn.com/dms/image/D4D12AQGxAhLwSMIA5A/article-cover_image-shrink_600_2000/0/1687786383069?e=2147483647&v=beta&t=9pfcOILHENkgqvVWKxW99dc9drJTvZc4qVQW8kPgCkE",
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
    ]
}
