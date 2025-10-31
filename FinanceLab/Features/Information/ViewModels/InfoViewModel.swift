//
//  InfoViewModel.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import Foundation

@Observable
class InfoViewModel {
    // Services
    var manager: UserManager = .shared
    var articleService = ArticleService()
    var articleContentService = ArticleContentService()
    
    // Affichage d'un message d'erreur explicite
    var error: Error = LoginError.unknown
    var showError: Bool = false
    
    //    Variables affichés dans les views.
    var articles: [Article] = []
    var tips: [Article] = []
    
    var carouselArticles: [Article] = []
    var latestArticles: [Article] = []
    
    var articleContent: [ArticleContent] = []
    

    
    func fetchArticles() async {
        do {
            articles = try await articleService.fetchArticles().filter({ $0.articleCategory == .article })
            
        } catch {
            self.error = error
            showError.toggle()
            print("Error fetching articles list: \(error)")
        }
    }
    
    func fetchArticleContents(idArticle: UUID) async {
        do {
            articleContent = try await articleContentService.fetchArticleContents(idArticle: idArticle)
            // Remettre les sections de l'article dans l'ordre
            articleContent = articleContent.sorted {
                ($0.orderPlacement < $1.orderPlacement)
            }
        } catch {
            self.error = error
            showError.toggle()
            print("Error fetching article contents: \(error)")
        }
    }
    
    func getLatestArticles() {
        latestArticles = articles.sorted {
            ($0.creationDate ?? .distantPast) > ($1.creationDate ?? .distantPast)
        }
    }
    
    func getCarouselArticles() {
        carouselArticles = Array(latestArticles.prefix(3))
    }
    
    func getTips() async {
        do {
            tips = try await articleService.fetchArticles().filter({ $0.articleCategory == .tips })
        } catch {
            self.error = error
            showError.toggle()
            print("Error fetching tips list: \(error)")
        }
    }
    
    func getGlossaire() -> [Glossaire] {
        return glossaires
    }
    
    func getRandomGlossaire() -> Glossaire {
        return glossaires.randomElement()!
    }
    
//    private let articlesTab: [Article] = [
//        Article(
//            title: "L’éducation financière : une clé pour mieux gérer son argent",
//            image: "https://d3hjf51r9j54j7.cloudfront.net/wp-content/uploads/sites/3/2019/05/financial-education-secondary-school.jpg",
//            content: [
//                .paragraph("Dans un monde où chaque décision du quotidien a une dimension économique — payer un café, contracter un prêt ou préparer sa retraite — l’éducation financière s’impose comme une compétence essentielle. Pourtant, beaucoup de personnes admettent ne pas comprendre certains mécanismes simples : comment fonctionne un taux d’intérêt ? Quelle différence entre épargne et investissement ? Ou encore, comment équilibrer son budget ?"),
//                
//                    .subtitle("Pourquoi l’éducation financière est-elle essentielle ?"),
//                .paragraph("L’éducation financière permet de reprendre le contrôle sur sa vie économique. Elle aide à comprendre les conséquences de ses choix, à anticiper les imprévus et à bâtir une stabilité à long terme. En comprenant mieux les produits bancaires, les impôts ou le fonctionnement du crédit, on devient plus autonome face aux institutions et aux aléas de la vie."),
//                
//                    .image(
//                        url: "https://optimiser-son-budget.com/wp-content/uploads/2023/09/reme-visage-51.png",
//                        caption: "Apprendre à gérer son argent, un investissement durable."
//                    ),
//                
//                    .subtitle("Les notions de base à connaître"),
//                .list(items: [
//                    "Établir un budget et suivre ses dépenses pour savoir où part son argent.",
//                    "Constituer une épargne de précaution pour faire face aux imprévus.",
//                    "Différencier épargne, placement et investissement selon les objectifs.",
//                    "Comprendre le coût réel du crédit et des taux d’intérêt.",
//                    "Anticiper la retraite, les impôts et les changements de situation personnelle."
//                ]),
//                
//                    .paragraph("Ces notions, une fois acquises, permettent d’adopter des réflexes sains : évaluer avant d’acheter, planifier avant d’investir, et réfléchir avant d’emprunter. L’éducation financière ne promet pas la richesse, mais elle garantit la tranquillité d’esprit."),
//                
//                    .subtitle("Comment développer sa culture financière ?"),
//                .paragraph("Les ressources ne manquent pas : livres, podcasts, applications de gestion budgétaire, simulateurs bancaires et cours en ligne. Commencer par observer ses habitudes de consommation est souvent la première étape. Savoir où va son argent, c’est déjà commencer à le maîtriser."),
//                
//                    .subtitle("En conclusion"),
//                .paragraph("Développer sa culture financière, c’est investir dans sa liberté. Plus on comprend les mécanismes économiques, plus on fait des choix alignés avec ses valeurs et ses projets. C’est un apprentissage continu, mais chaque petit pas compte vers une vie plus sereine et équilibrée.")
//            ]
//        ),
    
//        Article(
//            title: "Gérer son budget au quotidien : les bons réflexes",
//            image: "https://onbudgetmoms.com/wp-content/uploads/2018/09/Budgeting.jpg",
//            content: [
//                .paragraph("Un budget n’est pas une contrainte, mais un outil de liberté. Savoir où va son argent, c’est se donner la possibilité de choisir, de planifier et de réaliser ses projets sans stress financier. Pourtant, beaucoup associent encore le mot 'budget' à la privation."),
//                
//                    .subtitle("Pourquoi établir un budget ?"),
//                .paragraph("Faire un budget, c’est reprendre la main sur ses finances. Cela permet d’éviter les dépenses impulsives, de prévenir les découverts et de repérer les marges de manœuvre. C’est aussi la première étape pour épargner et investir sereinement."),
//                
//                    .image(
//                        url: "https://www.abcfortune.com/wp-content/uploads/2018/09/gestion-budget.jpg",
//                        caption: "Un budget équilibré permet de vivre sereinement."
//                    ),
//                
//                    .subtitle("Les étapes d’un bon budget"),
//                .list(items: [
//                    "Lister ses revenus (salaire, aides, revenus secondaires).",
//                    "Identifier les dépenses fixes incompressibles : logement, factures, abonnements.",
//                    "Évaluer les dépenses variables : alimentation, transport, loisirs.",
//                    "Fixer un montant d’épargne automatique dès le début du mois.",
//                    "Analyser régulièrement les écarts entre prévisionnel et réel."
//                ]),
//                
//                    .paragraph("Une méthode simple consiste à répartir son budget selon la règle des 50/30/20 : 50 % pour les besoins essentiels, 30 % pour les envies, et 20 % pour l’épargne. C’est une base flexible, mais efficace pour débuter."),
//                
//                    .subtitle("Les outils de suivi"),
//                .paragraph("Aujourd’hui, les applications mobiles comme Bankin’, Linxo ou YNAB facilitent la visualisation des dépenses. Un simple tableau Excel peut aussi suffire. L’essentiel n’est pas l’outil, mais la régularité. Prendre 10 minutes chaque semaine pour vérifier ses comptes évite les mauvaises surprises."),
//                
//                    .subtitle("Conclusion"),
//                .paragraph("Un budget bien géré n’est pas une prison, mais une boussole. Il permet d’affronter les imprévus avec calme et de financer ses projets en toute confiance.")
//            ]
//        ),
//        Article(
//            title: "L’épargne, un pilier de la stabilité financière",
//            image: "https://zoneled.fr/wp-content/uploads/2020/07/tirelire-2048x1365.jpg",
//            content: [
//                .paragraph("Épargner, c’est se donner une marge de sécurité. Cela ne signifie pas forcément mettre beaucoup de côté, mais surtout le faire régulièrement. Une épargne bien gérée est une assurance contre les coups durs et une base solide pour préparer ses projets."),
//                
//                    .subtitle("Pourquoi épargner ?"),
//                .paragraph("L’épargne protège des imprévus et offre des opportunités. Une panne de voiture, une dépense médicale, ou même un changement de travail peuvent survenir à tout moment. Disposer d’une réserve permet de réagir sans stress ni recours au crédit."),
//                
//                    .image(
//                        url: "https://www.plusdefric.com/wp-content/uploads/2018/08/comment-faire-pour-mieux-epargner.jpg",
//                        caption: "Épargner, c’est se donner les moyens d’agir librement."
//                    ),
//                
//                    .subtitle("Les différents types d’épargne"),
//                .list(items: [
//                    "L’épargne de précaution : liquide et disponible, elle couvre 3 à 6 mois de dépenses.",
//                    "L’épargne projet : dédiée à un objectif concret (voyage, achat, formation).",
//                    "L’épargne de long terme : pour la retraite, la transmission ou les placements à rendement."
//                ]),
//                
//                    .paragraph("Diversifier ses supports d’épargne est important : livret A, assurance-vie, PEL, voire compte-titres. Chaque produit a ses avantages, sa fiscalité et son horizon de placement. L’essentiel est de choisir en fonction de ses besoins et de son niveau de risque."),
//                
//                    .subtitle("Comment commencer à épargner ?"),
//                .paragraph("Commencer petit est souvent plus efficace que de ne rien faire. 20 ou 50 euros par mois suffisent pour créer l’habitude. L’automatisation est la clé : un virement programmé au début du mois transforme l’épargne en réflexe."),
//                
//                    .subtitle("Conclusion"),
//                .paragraph("Épargner, ce n’est pas se priver : c’est se préparer. C’est la base d’une autonomie financière durable, qui permet d’affronter la vie avec plus de sérénité et d’ambition.")
//            ]
//        ),
//        Article(
//            title: "Comprendre l’investissement : faire fructifier son argent intelligemment",
//            image: "https://st.depositphotos.com/1592314/1417/i/950/depositphotos_14176215-stock-photo-euro-coins-and-banknotes-on.jpg",
//            content: [
//                .paragraph("Investir, c’est faire travailler son argent pour soi. Contrairement à l’épargne, qui protège, l’investissement vise à faire croître le capital sur le long terme. Mais il implique aussi des risques, qu’il faut apprendre à comprendre et à maîtriser."),
//                
//                    .subtitle("Pourquoi investir ?"),
//                .paragraph("L’investissement permet de compenser l’inflation et de préparer l’avenir. Les intérêts composés — le fait que les gains génèrent à leur tour des gains — transforment le temps en un allié puissant. C’est pourquoi investir tôt, même de petites sommes, peut avoir un impact considérable sur la durée."),
//                
//                    .subtitle("Les principaux types d’investissement"),
//                .list(items: [
//                    "Les placements financiers : actions, obligations, fonds communs ou ETF.",
//                    "L’immobilier : achat locatif, résidence principale ou SCPI.",
//                    "Les investissements responsables (ISR) : placer son argent dans des entreprises durables.",
//                    "Les alternatives : or, cryptomonnaies, crowdfunding."
//                ]),
//                
//                    .image(
//                        url: "https://www.amf-france.org/sites/institutionnel/files/dam/6fb4839e-18a6-4842-8161-cab7c85d6bca/Rendement_risque.jpg",
//                        caption: "Investir, c’est accepter un risque pour viser un rendement."
//                    ),
//                
//                    .subtitle("Les bonnes pratiques"),
//                .paragraph("Investir sans comprendre, c’est spéculer. Avant toute décision, il faut définir son profil d’investisseur : prudent, équilibré ou dynamique. Diversifier ses placements limite les risques. Et surtout, il faut investir avec une vision long terme, sans se laisser influencer par les émotions du marché."),
//                
//                    .paragraph("Les plateformes d’investissement en ligne ont rendu ces produits accessibles, mais la prudence reste de mise. Prendre le temps de se former, de lire, et de poser des questions est la meilleure protection contre les décisions hâtives."),
//                
//                    .subtitle("Conclusion"),
//                .paragraph("L’investissement n’est pas réservé aux experts. C’est une compétence que chacun peut développer à son rythme. Avec méthode et patience, il devient un formidable levier pour construire son indépendance financière et réaliser ses ambitions.")
//            ]
//        ),
//    ]
    
//    private let tips: [Article] = [
//        Article(
//            title: "Astuce : Définir ses priorités de dépenses",
//            content: [
//                .paragraph("Avant de dépenser, classez vos besoins selon trois catégories : essentiel, important, et plaisir. Cela aide à repérer les achats impulsifs et à préserver un équilibre entre plaisir immédiat et sécurité financière. Par exemple, les abonnements oubliés font souvent partie des dépenses 'plaisir' qu’on peut réduire sans frustration.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Utiliser la règle des 24 heures",
//            content: [
//                .paragraph("Face à une envie d’achat non urgente, attendez 24 heures avant de décider. Ce petit délai permet de distinguer les envies passagères des vrais besoins. Dans la plupart des cas, l’envie disparaît et votre compte vous remerciera !")
//            ]
//        ),
//        Article(
//            title: "Astuce : Automatisez votre épargne",
//            content: [
//                .paragraph("Programmez un virement automatique vers votre compte épargne juste après la réception de votre salaire. Cela transforme l’épargne en habitude et non en option. Même une petite somme, mise de côté chaque mois sans y penser, fait une grande différence à long terme.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Fixez un plafond de dépenses hebdomadaire",
//            content: [
//                .paragraph("Plutôt que de viser un budget mensuel abstrait, déterminez un montant maximal à dépenser chaque semaine. C’est plus concret et plus motivant. Si vous dépensez moins une semaine, gardez la différence pour un petit plaisir ou pour renforcer votre épargne.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Le suivi visuel de vos finances",
//            content: [
//                .paragraph("Utilisez un tableau ou une application pour visualiser votre budget. Voir vos progrès sous forme de graphiques ou de pourcentages renforce la motivation. Les outils visuels transforment les chiffres en comportements concrets."),
//                .paragraph("Par exemple, voir la part de vos dépenses de loisirs diminuer de 30 % à 20 % en un mois est plus parlant qu’un simple total en euros.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Négociez vos contrats",
//            content: [
//                .paragraph("Assurance, téléphone, énergie : beaucoup de contrats peuvent être renégociés chaque année. Une simple comparaison de tarifs ou un appel à votre fournisseur peut vous faire économiser plusieurs dizaines d’euros par mois. Notez la date de renouvellement de vos contrats pour ne jamais laisser passer cette opportunité.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Construisez un fonds d’urgence",
//            content: [
//                .paragraph("Essayez de mettre de côté l’équivalent d’un à trois mois de dépenses essentielles. Ce coussin de sécurité vous protège en cas d’imprévu (réparation, perte d’emploi, facture urgente). Ce n’est pas un luxe, c’est une priorité : il évite de devoir emprunter à court terme.")
//            ]
//        ),
//        Article(
//            title: "Astuce : La règle du 50/30/20",
//            content: [
//                .paragraph("Répartissez vos revenus ainsi : 50 % pour les besoins essentiels (logement, nourriture, transport), 30 % pour les envies et loisirs, 20 % pour l’épargne ou le remboursement de dettes. Ce modèle simple aide à garder un équilibre sans se sentir limité.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Surveillez les petites dépenses",
//            content: [
//                .paragraph("Un café par jour à 3 €, c’est plus de 1 000 € par an. Ces 'petits plaisirs' ne sont pas à bannir, mais à encadrer. En prendre conscience permet de choisir lesquels garder, et lesquels réduire pour dégager du budget sans contrainte.")
//            ]
//        ),
//        Article(
//            title: "Astuce : Séparez vos comptes",
//            content: [
//                .paragraph("Avoir plusieurs comptes aide à mieux gérer : un pour les dépenses fixes, un pour les loisirs, un pour l’épargne. Cette séparation mentale et pratique évite de piocher dans l’argent destiné à autre chose."),
//                .paragraph("C’est une manière simple de rendre la gestion financière plus claire et de diminuer le stress lié à la peur d’un découvert.")
//            ]
//        )
//    ]
    
    private let glossaires: [Glossaire] = [
        Glossaire(title: "Action", description: "Titre qui représente une petite part de propriété d'une entreprise. En acheter, c'est devenir 'co-propriétaire' et espérer profiter des bénéfices si l'entreprise se porte bien."),
        Glossaire(title: "Actif", description: "Tout ce qui a de la valeur et qui peut appartenir à une personne (argent, maison, voiture, placements financiers). Les actifs peuvent générer des revenus ou prendre de la valeur avec le temps."),
        Glossaire(title: "Amortissement", description: "Répartition du coût d’un bien sur plusieurs années. Par exemple, une voiture achetée 10 000 € perd de la valeur chaque année : c’est son amortissement."),
        Glossaire(title: "Assurance", description: "Contrat qui protège financièrement contre certains risques (maladie, accident, vol, incendie). En échange d'une cotisation régulière, l'assureur couvre tout ou une partie des pertes éventuelles."),
        Glossaire(title: "Banque", description: "Institution financière qui garde ton argent, propose des moyens de paiement, des crédits et des produits d’épargne."),
        Glossaire(title: "Bourse", description: "Marché où s’échangent des actions, obligations ou autres titres financiers. C’est un lieu virtuel où se rencontrent acheteurs et vendeurs."),
        Glossaire(title: "Budget", description: "Outil de gestion permettant de comparer ses revenus et ses dépenses. Il sert à savoir combien on peut épargner, investir ou consommer sans dépasser ses moyens."),
        Glossaire(title: "Capital", description: "Somme d’argent ou valeur de départ utilisée pour créer un revenu ou une entreprise. C’est la base sur laquelle on construit de la richesse."),
        Glossaire(title: "Carte de crédit", description: "Moyen de paiement qui permet d’acheter maintenant et de rembourser plus tard, souvent avec des intérêts si le solde n’est pas payé à temps."),
        Glossaire(title: "Compte courant", description: "Compte bancaire utilisé au quotidien pour déposer son salaire, payer ses factures ou retirer de l’argent."),
        Glossaire(title: "Compte épargne", description: "Compte bancaire destiné à mettre de l’argent de côté. Il rapporte souvent des intérêts selon la somme déposée."),
        Glossaire(title: "Crédit", description: "Somme d’argent empruntée à une banque ou un organisme. Il faut la rembourser avec des intérêts, sur une durée définie."),
        Glossaire(title: "Crédit immobilier", description: "Prêt utilisé pour acheter un bien immobilier (maison, appartement). Il s’étale généralement sur 15 à 25 ans."),
        Glossaire(title: "Crypto-monnaie", description: "Monnaie numérique décentralisée, comme le Bitcoin, qui fonctionne sans banque centrale et repose sur la technologie de la blockchain."),
        Glossaire(title: "Débit", description: "Somme d’argent qui sort d’un compte bancaire. Par exemple, un paiement par carte ou un prélèvement."),
        Glossaire(title: "Déficit", description: "Situation où les dépenses sont supérieures aux revenus. C’est l’opposé de l’excédent."),
        Glossaire(title: "Dépense", description: "Somme d’argent utilisée pour acheter un bien ou un service. Suivre ses dépenses permet de mieux gérer son budget."),
        Glossaire(title: "Diversification", description: "Stratégie qui consiste à répartir ses investissements sur plusieurs types d’actifs pour réduire les risques."),
        Glossaire(title: "Dividende", description: "Part des bénéfices qu’une entreprise verse à ses actionnaires, généralement une fois par an."),
        Glossaire(title: "Épargne", description: "Argent mis de côté pour des projets futurs ou pour se protéger des imprévus."),
        Glossaire(title: "Épargne de précaution", description: "Somme mise de côté pour faire face aux urgences (panne, perte d’emploi, frais médicaux). Généralement 3 à 6 mois de dépenses."),
        Glossaire(title: "Emprunt", description: "Fait d’obtenir de l’argent d’un prêteur (banque, particulier) en s’engageant à le rembourser avec des intérêts."),
        Glossaire(title: "Fonds d’investissement", description: "Portefeuille collectif géré par des professionnels qui investissent dans différentes entreprises ou obligations."),
        Glossaire(title: "Impôt", description: "Somme versée à l’État pour financer les services publics (éducation, santé, sécurité…). Le montant dépend des revenus et du patrimoine."),
        Glossaire(title: "Inflation", description: "Hausse générale et durable des prix. Elle diminue le pouvoir d’achat de la monnaie."),
        Glossaire(title: "Intérêt", description: "Somme versée en échange d’un prêt d’argent. C’est le 'prix' du temps ou du risque."),
        Glossaire(title: "Investissement", description: "Achat d’un actif dans l’objectif de le voir prendre de la valeur ou générer un revenu futur."),
        Glossaire(title: "Liquidité", description: "Capacité à transformer rapidement un actif en argent liquide sans perte de valeur."),
        Glossaire(title: "Monnaie", description: "Instrument d’échange accepté par tous pour acheter des biens et des services."),
        Glossaire(title: "Obligation", description: "Titre de dette émis par une entreprise ou un État. L’investisseur prête de l’argent en échange d’un remboursement futur avec intérêts."),
        Glossaire(title: "Patrimoine", description: "Ensemble des biens qu’une personne possède (immobilier, placements, objets de valeur…)."),
        Glossaire(title: "Pension", description: "Revenu régulier versé à une personne après sa retraite, souvent issu de cotisations versées durant sa vie active."),
        Glossaire(title: "Placements", description: "Utilisation de son argent pour le faire fructifier (livret, assurance-vie, bourse, immobilier…)."),
        Glossaire(title: "Pouvoir d’achat", description: "Quantité de biens et services que l’on peut acheter avec un certain revenu. Il baisse quand les prix augmentent."),
        Glossaire(title: "Prêt à taux zéro", description: "Crédit sans intérêts, souvent accordé pour aider à acheter un logement sous certaines conditions."),
        Glossaire(title: "Revenu", description: "Argent perçu régulièrement (salaire, allocations, loyers, dividendes…). C’est ce qui alimente ton budget."),
        Glossaire(title: "Risque", description: "Possibilité de perdre une partie de son argent lorsqu’on investit. Plus le rendement espéré est élevé, plus le risque l’est aussi."),
        Glossaire(title: "Salaire", description: "Rémunération reçue en échange d’un travail fourni. Il peut être fixe ou inclure des primes."),
        Glossaire(title: "Solvabilité", description: "Capacité d’une personne à rembourser ses dettes. Une bonne solvabilité facilite l’accès au crédit."),
        Glossaire(title: "Taux d’intérêt", description: "Pourcentage appliqué à un prêt ou à un placement pour calculer les intérêts dus ou gagnés."),
        Glossaire(title: "Titre", description: "Document ou valeur financière représentant un droit de propriété (action) ou de créance (obligation)."),
        Glossaire(title: "Transaction", description: "Opération d’achat ou de vente d’un bien, d’un service ou d’un titre financier."),
        Glossaire(title: "Valeur ajoutée", description: "Différence entre le prix de vente d’un produit et le coût de ses matières premières. C’est la richesse créée par l’entreprise."),
        Glossaire(title: "Volatilité", description: "Mesure des variations de prix d’un actif. Plus un actif est volatile, plus son prix change rapidement."),
        Glossaire(title: "Zone euro", description: "Ensemble des pays européens utilisant l’euro comme monnaie commune. Ils partagent une même politique monétaire.")
    ]
}
