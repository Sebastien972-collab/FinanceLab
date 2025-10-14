//
//  UserCardProfile.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import SwiftUI

struct UserCardProfile: View {
    let user: User
    var body: some View {
        NavigationLink {
            UserProfileView()
        } label: {
            StandardCard {
                HStack(alignment: .center) {
                    CircleImageProfil(urlImage: user.profilePictureUrl)
                        .padding(.vertical, 5)
                    VStack(alignment: .leading) {
                        Text(user.displayName)
                            .font(Font.cardTitle)
                            .foregroundStyle(Color.Text.primary)
                        Text("Profil financier")
                            .font(Font.cardSubtitle)
                            .foregroundStyle(Color.Text.primary)
                    }
                }
            }
        }

    }
}

#Preview {
    UserCardProfile(user: .preview)
        .padding()
}
