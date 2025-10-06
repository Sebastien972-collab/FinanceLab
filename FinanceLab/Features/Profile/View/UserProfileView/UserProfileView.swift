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
                StandardCard {
                    HStack{
                        VStack(alignment: .leading) {
                            Text("Sophie")
                            Text("sohphie@gmail.com")
                        }
                        .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        CircleImageProfil(urlImage: User.userDatabase[2].profilePictureUrl)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                ContinuButtonView(
                    title: "Répond à une autre question ",
                    state: .validate,
                    action: {}
                )
                
                Spacer()
                
            }
            .navigationTitle(Text("Mon profil"))
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
