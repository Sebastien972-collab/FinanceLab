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
            HStack(spacing: 12) {
                CircleImageProfil(urlImage: tabVm.manager.currentUser.profilePictureUrl)
                    .frame(width: 44, height: 44)
                VStack(alignment: .leading, spacing: 2) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bienvenue")
                            .font(.cardSubtitle)
                        Text(tabVm.manager.currentUser.displayName)
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
