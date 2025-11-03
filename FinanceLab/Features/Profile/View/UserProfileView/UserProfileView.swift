//
//  UserProfileView.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(TabViewModel.self) private var tabVm: TabViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showLogoutAlert: Bool = false
    @State var profilVM = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Mon profil")
                        .font(.title)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Informations du compte")
                        StandardCard {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tabVm.currentUser.firstName)
                                        .font(.cardTitle)
                                    Text(verbatim: tabVm.currentUser.email)
                                        .font(.cardSubtitle)
                                }
                                .foregroundStyle(Color.Text.primary)
                                Spacer()
                                CircleImageProfil(urlImage: profilVM.currentUser.profilePictureUrl)
                                    .frame(width: 55, height: 55)
                            }
                            .padding()
                        }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                    Text("Profil financier")
                    ContinuButtonView (
                        title: "Répondre à plus de questions ",
                        state: .validate,
                        action: {}
                    )
                    ForEach(profilVM.userAnswers) { answer in
                        CardProfil(
                            iconName: answer.question.questionGroup.icon.resource,
                            title: answer.question.questionGroup.titlePrefix,
                            subtitle: answer.question.label,
                            content:  (answer.question.followUpLabel ?? "") + " : " + answer.content
                        )
                    }
                }
                DemboCard {
                    Text("Plus tu complètes ton profil financier, plus mes conseils seront précis et utiles !")
                }
            }
                .font(.header)
                .foregroundStyle(Color.Text.contrasted)
                .padding()
        }
            .alert("Se déconnecter", isPresented: $showLogoutAlert) {
                Button("Se déconnecter", role: .destructive) {
                    tabVm.logout()
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Voulez-vous vraiment vous déconnecter de votre compte ?")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right.fill") {
                        showLogoutAlert = true
                    }
                    .buttonStyle(FinanceButton(state: .cancel, size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .navigation) {
                    Button("Précédent", systemImage: "chevron.left") {
                        dismiss()
                    }
                    .buttonStyle(FinanceButton(size: .round))
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .navigationBarBackButtonHidden()
            .background {
                FinancialBackground()
                    .ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    UserProfileView()
        .environment(TabViewModel())
}

