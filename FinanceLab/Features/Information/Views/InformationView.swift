//
//  InformationView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 14/10/2025.
//

import SwiftUI

struct InformationView: View {
    @State var infoVM = InfoViewModel()
    @State var randomDefinition = Definition(name: "", content: "")
    
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
                        NavigationLink(destination: DefinitionView().environment(infoVM)) {
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
                            Text(LocalizedStringResource("Un mot au hasard : **\(infoVM.randomDefinition.name)**"))
                            Text(infoVM.randomDefinition.content).lineLimit(2)
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            isPresented = true
                        }
                }
            }
            .foregroundStyle(Color.Text.contrasted)
            .padding(.vertical)
            .task {
                await infoVM.fetchArticles()
                await infoVM.getRandomDefinition()
                await infoVM.getTips()
                infoVM.getLatestArticles()
                infoVM.getCarouselArticles()
            }
            
            
            .sheet(isPresented: $isPresented) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Le mot du jour")
                            .font(.title)
                        Text(infoVM.randomDefinition.name)
                            .font(.title2)
                        Text(infoVM.randomDefinition.content)
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
