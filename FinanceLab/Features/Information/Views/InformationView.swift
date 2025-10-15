//
//  InformationView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct InformationView: View {
    @State var infoVM = InfoViewModel()
    @State var randomGlossaire = Glossaire(title: "", description: "")
        
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
                        NavigationLink(destination: ArticleListView().environment(infoVM)) {
                            InfoPickCard(
                                label: "Articles",
                                icon: .newspaperClippingFill
                            )
                        }
                        NavigationLink(destination: ArticleListView(isTips: true).environment(infoVM)) {
                            InfoPickCard(
                                label: "Astuces",
                                icon: .lightbulbFill
                            )
                        }
                        NavigationLink(destination: GlossaireView().environment(infoVM)) {
                            InfoPickCard(
                                label: "Glossaire",
                                icon: .bookOpenTextFill
                            )
                        }
                    }
                    .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            Spacer()
                                .frame(width: 6)
                            ForEach(infoVM.getCarouselArticles()) { article in
                                NavigationLink(destination: SingleArticleView(article: article)) {
                                    InfoCarouselCard(article: article)
                                }
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                    }
                    .frame(height: 225)
                    NavigationLink(destination: GlossaireView().environment(infoVM)) {
                        DemboCard() {
                            Text("Le mot du jour : \(randomGlossaire.title)")
                            Text(randomGlossaire.description).lineLimit(3)
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        randomGlossaire = infoVM.getRandomGlossaire()
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
