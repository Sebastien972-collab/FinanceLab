//
//  InformationView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct InformationView: View {
    @State var infoVM = InfoViewModel()
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("S'informer")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.horizontal)
                    HStack(spacing: 10) {
                        InfoPickCard(
                            label: "Articles",
                            icon: .newspaperClippingFill
                        )
                        InfoPickCard(
                            label: "Astuces",
                            icon: .lightbulbFill
                        )
                        NavigationLink(destination: GlossaireView()) {
                            InfoPickCard(
                                label: "Glossaire",
                                icon: .bookOpenTextFill
                            )
                        }
                    }
                    .padding(.horizontal)
                    LazyHStack {
                        ForEach(infoVM.getCarouselArticles()) { article in
                            NavigationLink(destination: ArticleView(article: article)) {
                                InfoCarouselCard(article: article)
                            }
                        }
                    }
                    if let randomGlossaire = glossaires.randomElement() {
                        NavigationLink(destination: GlossaireView()) {
                            DemboCard() {
                                Text("Le mot du jour : \(randomGlossaire.title)")
                                Text(randomGlossaire.description).lineLimit(3)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .foregroundStyle(Color.Text.contrasted)
            .padding(.vertical)
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    InformationView()
}
