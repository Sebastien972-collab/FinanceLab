//
//  UserCardProfile.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import SwiftUI

struct UserCardProfile: View {
    @Environment(UserViewModel.self) private var userVM
    @State private var isPresented: Bool = false
    let profileVm = ProfileViewModel()
    var body: some View {
        StandardCard {
            HStack(alignment: .center) {
                CircleImageProfil(urlImage: userVM.currentUser.profilePictureUrl)
                    .padding(.vertical, 5)
                VStack(alignment: .leading) {
                    Text(userVM.currentUser.displayName)
                        .font(Font.cardTitle)
                        .foregroundStyle(Color.Text.primary)
                    Text("Profil financier")
                        .font(Font.cardSubtitle)
                        .foregroundStyle(Color.Text.primary)
                }
            }
        }
        .onTapGesture {
            profileVm.userVm = userVM
            isPresented.toggle()
        }
        .navigationDestination(isPresented: $isPresented) {
            UserProfileView(profilVM: profileVm, )
        }

    }
}

#Preview {
    UserCardProfile()
        .padding()
        .environment(UserViewModel())
}
