//
//  UserProfileView.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct UserProfileView: View {
    @State var profilVM = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
                ScrollView {
                    VStack(spacing:24 ) {
                    VStack(alignment: .leading) {
                        Text("Réglages du compte")
                            .font(Font.header)
                            .foregroundStyle(Color.Text.contrasted)
                        StandardCard {
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(profilVM.currentUser.firstName)
                                        .font(Font.body)
                                    Text(verbatim: profilVM.currentUser.email)
                                        .font(Font.body)
                                }
                                .foregroundStyle(Color.Text.primary)
                                Spacer()
                                CircleImageProfil(urlImage: profilVM.currentUser.profilePictureUrl)
                                    .clipShape(Circle())
                            }
                            .padding()
                            
                        }
                        
                    }
                    
                        VStack(alignment: .leading, spacing: 12) {
                        Text("Profil Financier ")
                            .font(Font.header)
                            .foregroundStyle(Color.Text.contrasted)
                        ContinuButtonView (
                            title: "Répond à une autre question ",
                            state: .validate,
                            action: {}
                        )
                        CardProfil(iconName: .currencyEurFill, title: "Emploi", subtitle: ["Je suis en CDI", "je gagne 1300 € / mois ",])
                        CardProfil(iconName: .houseLineFill, title: "Emploi", subtitle: ["Je suis en CDI", "je gagne 1300 € / mois ",])
                    }
                    
                    DemboCard {
                        Text("Plus tu complètes ton profil financier, plus mes conseil seront précis et utiles")
                    }
                    
                    Spacer()
                    
                }
                .foregroundStyle(Color.Text.contrasted)
                
                
                
                
            }
            .navigationTitle(Text("Mon profil"))
            .padding(.horizontal)
            .background {
                FinancialBackground()
                    .ignoresSafeArea(.all)
            }
            
        }
        
        
    }
}

#Preview {
    UserProfileView()
}
