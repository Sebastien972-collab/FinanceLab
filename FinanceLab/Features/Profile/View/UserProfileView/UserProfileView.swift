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
            ZStack{
                FinancialBackground()
                    .ignoresSafeArea()
                VStack{
                    StandardCard {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Sophie")
                                Text("sophie.martin@example.com")
                            }
                            .font(Font.cardCallout)
                            .foregroundStyle(Color.Text.contrasted)
                            
                            Spacer()
                            CircleImageProfil(urlImage: User.userDatabase[2].profilePictureUrl)
                            
                        }
                        .padding()
                    }
                    
                    ContinuButtonView(
                        title: "Répond à une autre question ",
                        state: .validate,
                        action: {}
                    )
                    .frame(maxWidth: 390)
                    .font( Font.buttonLabel)
                    .foregroundStyle(Color.Text.primary)
                    
                }
                
             
            }
            .navigationTitle(Text("Mon profil"))
            .font(Font.title)
            .foregroundStyle(Color.Text.contrasted)
        }
       
       
    }
}

#Preview {
    UserProfileView()
}
