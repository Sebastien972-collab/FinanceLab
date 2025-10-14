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
        let art = articles
        return Array(art.prefix(4))
    }
    
    func getLatestArticles() -> [Article] {
        let art = articles
        return Array(art).reversed()
    }
    
    private let articles: [Article] = [
        Article(
            title: "L’éducation financière : une clé pour mieux gérer son argent",
            category: .article,
            image: "https://d3hjf51r9j54j7.cloudfront.net/wp-content/uploads/sites/3/2019/05/financial-education-secondary-school.jpg",
            content: [
                .paragraph("Dans un monde où chaque décision du quotidien a une dimension économique — payer un café, contracter un prêt ou préparer sa retraite — l’éducation financière s’impose comme une compétence essentielle. Pourtant, beaucoup de personnes admettent ne pas comprendre certains mécanismes simples : comment fonctionne un taux d’intérêt ? Quelle différence entre épargne et investissement ? Ou encore, comment équilibrer son budget ?"),

                .subtitle("Pourquoi l’éducation financière est-elle essentielle ?"),
                .paragraph("L’éducation financière permet de reprendre le contrôle sur sa vie économique. Elle aide à comprendre les conséquences de ses choix, à anticiper les imprévus et à bâtir une stabilité à long terme. En comprenant mieux les produits bancaires, les impôts ou le fonctionnement du crédit, on devient plus autonome face aux institutions et aux aléas de la vie."),

                .image(
                    url: "https://optimiser-son-budget.com/wp-content/uploads/2023/09/reme-visage-51.png",
                    caption: "Apprendre à gérer son argent, un investissement durable."
                ),

                .subtitle("Les notions de base à connaître"),
                .list(items: [
                    "Établir un budget et suivre ses dépenses pour savoir où part son argent.",
                    "Constituer une épargne de précaution pour faire face aux imprévus.",
                    "Différencier épargne, placement et investissement selon les objectifs.",
                    "Comprendre le coût réel du crédit et des taux d’intérêt.",
                    "Anticiper la retraite, les impôts et les changements de situation personnelle."
                ]),

                .paragraph("Ces notions, une fois acquises, permettent d’adopter des réflexes sains : évaluer avant d’acheter, planifier avant d’investir, et réfléchir avant d’emprunter. L’éducation financière ne promet pas la richesse, mais elle garantit la tranquillité d’esprit."),

                .subtitle("Comment développer sa culture financière ?"),
                .paragraph("Les ressources ne manquent pas : livres, podcasts, applications de gestion budgétaire, simulateurs bancaires et cours en ligne. Commencer par observer ses habitudes de consommation est souvent la première étape. Savoir où va son argent, c’est déjà commencer à le maîtriser."),

                .subtitle("En conclusion"),
                .paragraph("Développer sa culture financière, c’est investir dans sa liberté. Plus on comprend les mécanismes économiques, plus on fait des choix alignés avec ses valeurs et ses projets. C’est un apprentissage continu, mais chaque petit pas compte vers une vie plus sereine et équilibrée.")
            ]
        ),
        Article(
            title: "Gérer son budget au quotidien : les bons réflexes",
            category: .article,
            image: "https://onbudgetmoms.com/wp-content/uploads/2018/09/Budgeting.jpg",
            content: [
                .paragraph("Un budget n’est pas une contrainte, mais un outil de liberté. Savoir où va son argent, c’est se donner la possibilité de choisir, de planifier et de réaliser ses projets sans stress financier. Pourtant, beaucoup associent encore le mot 'budget' à la privation."),

                .subtitle("Pourquoi établir un budget ?"),
                .paragraph("Faire un budget, c’est reprendre la main sur ses finances. Cela permet d’éviter les dépenses impulsives, de prévenir les découverts et de repérer les marges de manœuvre. C’est aussi la première étape pour épargner et investir sereinement."),

                .image(
                    url: "https://www.abcfortune.com/wp-content/uploads/2018/09/gestion-budget.jpg",
                    caption: "Un budget équilibré permet de vivre sereinement."
                ),

                .subtitle("Les étapes d’un bon budget"),
                .list(items: [
                    "Lister ses revenus (salaire, aides, revenus secondaires).",
                    "Identifier les dépenses fixes incompressibles : logement, factures, abonnements.",
                    "Évaluer les dépenses variables : alimentation, transport, loisirs.",
                    "Fixer un montant d’épargne automatique dès le début du mois.",
                    "Analyser régulièrement les écarts entre prévisionnel et réel."
                ]),

                .paragraph("Une méthode simple consiste à répartir son budget selon la règle des 50/30/20 : 50 % pour les besoins essentiels, 30 % pour les envies, et 20 % pour l’épargne. C’est une base flexible, mais efficace pour débuter."),

                .subtitle("Les outils de suivi"),
                .paragraph("Aujourd’hui, les applications mobiles comme Bankin’, Linxo ou YNAB facilitent la visualisation des dépenses. Un simple tableau Excel peut aussi suffire. L’essentiel n’est pas l’outil, mais la régularité. Prendre 10 minutes chaque semaine pour vérifier ses comptes évite les mauvaises surprises."),

                .subtitle("Conclusion"),
                .paragraph("Un budget bien géré n’est pas une prison, mais une boussole. Il permet d’affronter les imprévus avec calme et de financer ses projets en toute confiance.")
            ]
        ),
        Article(
            title: "L’épargne, un pilier de la stabilité financière",
            category: .article,
            image: "https://zoneled.fr/wp-content/uploads/2020/07/tirelire-2048x1365.jpg",
            content: [
                .paragraph("Épargner, c’est se donner une marge de sécurité. Cela ne signifie pas forcément mettre beaucoup de côté, mais surtout le faire régulièrement. Une épargne bien gérée est une assurance contre les coups durs et une base solide pour préparer ses projets."),

                .subtitle("Pourquoi épargner ?"),
                .paragraph("L’épargne protège des imprévus et offre des opportunités. Une panne de voiture, une dépense médicale, ou même un changement de travail peuvent survenir à tout moment. Disposer d’une réserve permet de réagir sans stress ni recours au crédit."),

                .image(
                    url: "https://www.plusdefric.com/wp-content/uploads/2018/08/comment-faire-pour-mieux-epargner.jpg",
                    caption: "Épargner, c’est se donner les moyens d’agir librement."
                ),

                .subtitle("Les différents types d’épargne"),
                .list(items: [
                    "L’épargne de précaution : liquide et disponible, elle couvre 3 à 6 mois de dépenses.",
                    "L’épargne projet : dédiée à un objectif concret (voyage, achat, formation).",
                    "L’épargne de long terme : pour la retraite, la transmission ou les placements à rendement."
                ]),

                .paragraph("Diversifier ses supports d’épargne est important : livret A, assurance-vie, PEL, voire compte-titres. Chaque produit a ses avantages, sa fiscalité et son horizon de placement. L’essentiel est de choisir en fonction de ses besoins et de son niveau de risque."),

                .subtitle("Comment commencer à épargner ?"),
                .paragraph("Commencer petit est souvent plus efficace que de ne rien faire. 20 ou 50 euros par mois suffisent pour créer l’habitude. L’automatisation est la clé : un virement programmé au début du mois transforme l’épargne en réflexe."),

                .subtitle("Conclusion"),
                .paragraph("Épargner, ce n’est pas se priver : c’est se préparer. C’est la base d’une autonomie financière durable, qui permet d’affronter la vie avec plus de sérénité et d’ambition.")
            ]
        ),
        Article(
            title: "Comprendre l’investissement : faire fructifier son argent intelligemment",
            category: .article,
            image: "https://st.depositphotos.com/1592314/1417/i/950/depositphotos_14176215-stock-photo-euro-coins-and-banknotes-on.jpg",
            content: [
                .paragraph("Investir, c’est faire travailler son argent pour soi. Contrairement à l’épargne, qui protège, l’investissement vise à faire croître le capital sur le long terme. Mais il implique aussi des risques, qu’il faut apprendre à comprendre et à maîtriser."),

                .subtitle("Pourquoi investir ?"),
                .paragraph("L’investissement permet de compenser l’inflation et de préparer l’avenir. Les intérêts composés — le fait que les gains génèrent à leur tour des gains — transforment le temps en un allié puissant. C’est pourquoi investir tôt, même de petites sommes, peut avoir un impact considérable sur la durée."),

                .subtitle("Les principaux types d’investissement"),
                .list(items: [
                    "Les placements financiers : actions, obligations, fonds communs ou ETF.",
                    "L’immobilier : achat locatif, résidence principale ou SCPI.",
                    "Les investissements responsables (ISR) : placer son argent dans des entreprises durables.",
                    "Les alternatives : or, cryptomonnaies, crowdfunding."
                ]),

                .image(
                    url: "https://www.amf-france.org/sites/institutionnel/files/dam/6fb4839e-18a6-4842-8161-cab7c85d6bca/Rendement_risque.jpg",
                    caption: "Investir, c’est accepter un risque pour viser un rendement."
                ),

                .subtitle("Les bonnes pratiques"),
                .paragraph("Investir sans comprendre, c’est spéculer. Avant toute décision, il faut définir son profil d’investisseur : prudent, équilibré ou dynamique. Diversifier ses placements limite les risques. Et surtout, il faut investir avec une vision long terme, sans se laisser influencer par les émotions du marché."),

                .paragraph("Les plateformes d’investissement en ligne ont rendu ces produits accessibles, mais la prudence reste de mise. Prendre le temps de se former, de lire, et de poser des questions est la meilleure protection contre les décisions hâtives."),

                .subtitle("Conclusion"),
                .paragraph("L’investissement n’est pas réservé aux experts. C’est une compétence que chacun peut développer à son rythme. Avec méthode et patience, il devient un formidable levier pour construire son indépendance financière et réaliser ses ambitions.")
            ]
        ),
    ]
}
