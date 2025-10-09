//
//  UserProfileView.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        NavigationStack{
            VStack{
                VStack(alignment: .leading) {
                    Text("Réglages du compte")
                        .font(Font.header)
                        .foregroundStyle(Color.Text.contrasted)
                    StandardCard {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Sophie")
                                    .font(Font.custom("Host Grotesk", size: 12))
                                Text(verbatim: "sohphie@gmail.com")
                                    .font(Font.custom("Host Grotesk", size: 12))
                            }
                            .foregroundStyle(Color.Text.primary)
                            Spacer()
                            CircleImageProfil(urlImage: User.userDatabase[2].profilePictureUrl)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading){
                    Text("Profil Financier ")
                        .font(Font.header)
                        .foregroundStyle(Color.Text.contrasted)
                    ContinuButtonView(
                        title: "Répond à une autre question ",
                        state: .validate,
                        action: {}
                    )
                    CardProfil(iconName: .currencyEurFill, title: "Emploi", subtitle: ["Je suis en CDI", "je gagne 1300 € / mois ",])
                    CardProfil(iconName: .houseLineFill, title: "Emploi", subtitle: ["Je suis en CDI", "je gagne 1300 € / mois ",])
                }
                
                .padding(.horizontal)
                
                Spacer()
                
            }
            .navigationTitle(Text("Mon profil"))
            .foregroundStyle(Color.Text.contrasted)
            .font(Font.title)
            
            
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
