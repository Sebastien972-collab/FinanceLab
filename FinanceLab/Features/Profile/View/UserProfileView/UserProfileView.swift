//
//  UserProfileView.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteAlert: Bool = false
    @State var profilVM = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Mon profil")
                        .font(.title)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Informations du compte")
                        StandardCard {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(profilVM.currentUser.firstName)
                                        .font(.cardTitle)
                                    Text(verbatim: profilVM.currentUser.email)
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
                    Text("Plus tu complètes ton profil financier, plus mes conseil seront précis et utiles")
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text("Actions irréversibles")
                        .font(.header)
                    ContinuButtonView (
                        title: "Supprimer mon compte",
                        state: .cancel,
                        action: {
                            showDeleteAlert = true
                        }
                    )
                }
            }
                .font(.header)
                .foregroundStyle(Color.Text.contrasted)
                .padding()
        }
            .alert("Supprimer votre compte", isPresented: $showDeleteAlert) {
                Button("Supprimer", role: .destructive) {
                    // TODO: mettre ici l'action de suppression de compte
                    dismiss()
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Attention, cette action est irréversible. Toutes vos données seront perdues.")
            }
            .toolbar {
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
}

