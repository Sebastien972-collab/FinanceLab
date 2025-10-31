//
//  UserCardProfile.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import SwiftUI

struct UserCardProfile: View {
    @Environment(TabViewModel.self) private var tabVm: TabViewModel
    @State private var isPresented: Bool = false
    var body: some View {
        StandardCard {
            HStack(alignment: .center) {
                CircleImageProfil(urlImage: tabVm.manager.currentUser.profilePictureUrl)
                    .padding(.vertical, 5)
                VStack(alignment: .leading) {
                    Text(tabVm.manager.currentUser.displayName)
                        .font(Font.cardTitle)
                        .foregroundStyle(Color.Text.primary)
                    Text("Profil financier")
                        .font(Font.cardSubtitle)
                        .foregroundStyle(Color.Text.primary)
                }
            }
        }
        .onTapGesture {apGesture in
            isPresented.toggle()
        }
        .navigationDestination(isPresented: $isPresented) {
            UserProfileView()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    tabVm.logout()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                }

            }
        }
        
    }
}

#Preview {
    VStack {
        UserCardProfile()
            .padding()
            .environment(TabViewModel())
    }
}
