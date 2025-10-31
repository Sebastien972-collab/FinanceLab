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
                    .frame(width: 44, height: 44)
                VStack(alignment: .leading, spacing: 2) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bienvenue")
                            .font(.cardSubtitle)
                        Text(profileVm.userManager.currentUser.displayName)
                            .font(.cardTitle)
                            .foregroundStyle(Color.Text.primary)
                    }
                    Text("Profil financier")
                        .font(.cardCallout)
                        .foregroundStyle(Color.Text.primary)
                }
                .lineLimit(1)
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
