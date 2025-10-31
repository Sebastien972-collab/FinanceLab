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
    
    @State var isPresented: Bool = false
        
    
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
                            ForEach(infoVM.carouselArticles) { article in
                                NavigationLink(destination: SingleArticleView(article: article).environment(infoVM)) {
                                    InfoCarouselCard(article: article)
                                }
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                    }
                    .frame(height: 225)
                        DemboCard() {
                            Text(LocalizedStringResource("Le mot du jour : **\(randomGlossaire.title)**"))
                            Text(randomGlossaire.description).lineLimit(2)
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            isPresented = true
                        }
                }
            }
            .foregroundStyle(Color.Text.contrasted)
            .padding(.vertical)
            .onAppear {
                randomGlossaire = infoVM.getRandomGlossaire()
            }
            .task {
                await infoVM.fetchArticles()
                infoVM.getLatestArticles()
                infoVM.getCarouselArticles()
                await infoVM.getTips()
            }
            
            
            .sheet(isPresented: $isPresented) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Le mot du jour")
                            .font(.title)
                        Text(randomGlossaire.title)
                            .font(.title2)
                        Text(randomGlossaire.description)
                            .font(.body)
                    }
                    Spacer()
                }
                .padding(24)
                .foregroundStyle(Color.Text.contrasted)
                .presentationBackground {
                    Rectangle()
                        .foregroundStyle(Color.App.background)
                }
                .presentationDragIndicator(.hidden)
                .presentationDetents([.fraction(0.24)])
            }
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    InformationView()
}
