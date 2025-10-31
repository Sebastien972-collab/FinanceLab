//
//  UserCardProfile.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import SwiftUI

struct UserCardProfile: View {
    let profileVm = ProfileViewModel()
    var body: some View {
        StandardCard {
            HStack(spacing: 12) {
                CircleImageProfil(urlImage: profileVm.userManager.currentUser.profilePictureUrl)
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading) {
                    Text(profileVm.userManager.currentUser.displayName)
                        .font(Font.cardTitle)
                        .foregroundStyle(Color.Text.primary)
                    Text("Profil financier")
                        .font(Font.cardSubtitle)
                        .foregroundStyle(Color.Text.primary)
                }
            }
            .padding()
        }
    }
}

#Preview {
    VStack {

        UserCardProfile()
            .padding()
    }
}
