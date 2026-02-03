//
//  LiquidUserProfileView.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI

struct UserProfileView: View {
    @Environment(TabViewModel.self) private var tabVm
    @Environment(\.dismiss) private var dismiss
    
    @State private var profilVM = ProfileViewModel()
    // On garde une instance séparée pour le flow de questions
    @State private var financialVM = FinancialProfileViewModel()
    
    @State private var showQuestions = false
    @State private var showLogoutAlert = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Animé
                LiquidMeshBackground()
                    .ignoresSafeArea()
                
                // 2. Contenu
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        
                        // Header (Avatar + Nom)
                        profileHeader
                            .padding(.top, 40)
                        
                        // Section Actions Rapides
                        VStack(spacing: 16) {
                            // Bouton "Continuer le profil"
                            Button {
                                showQuestions = true
                            } label: {
                                LiquidGradientCardButton(
                                    title: "Compléter mon profil",
                                    subtitle: "Améliorez la précision de vos conseils",
                                    icon: "wand.and.stars",
                                    colors: [.blue, .purple]
                                )
                            }
                            
                            // Carte Mascotte
                            if profilVM.userAnswers.count < 5 {
                                LiquidDemboCard {
                                    Text("Plus je te connais, mieux je peux t'aider ! Réponds à quelques questions.")
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Section Historique (Réponses)
                        if !profilVM.userAnswers.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Mon Profil Financier")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 24)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(profilVM.userAnswers) { answer in
                                        LiquidAnswerRow(answer: answer)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Bouton Déconnexion (Discret en bas)
                        Button {
                            showLogoutAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Se déconnecter")
                            }
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.red.opacity(0.8))
                            .padding()
                            .background(.white.opacity(0.05))
                            .cornerRadius(16)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                .refreshable {
                    await profilVM.fetchUserData()
                }
            }
            .navigationDestination(isPresented: $showQuestions) {
                // On passe isNewQuestion: true pour forcer le mode "Questionnaire"
                FinancialQuestionView(isNewQuestion: true)
                    .environment(tabVm) // On repasse l'environnement si nécessaire
            }
            .alert("Déconnexion", isPresented: $showLogoutAlert) {
                Button("Annuler", role: .cancel) {}
                Button("Se déconnecter", role: .destructive) {
                    tabVm.logout()
                }
            } message: {
                Text("Êtes-vous sûr de vouloir nous quitter ?")
            }
            .task {
                await profilVM.fetchUserData()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar avec Glow
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 110, height: 110)
                    .blur(radius: 20)
                    .opacity(0.5)
                
                if let url = URL(string: profilVM.currentUser.profilePictureUrl ?? ""), ((profilVM.currentUser.profilePictureUrl?.isEmpty) == nil) {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 2))
                } else {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 1))
                        .overlay(
                            Text(profilVM.initials)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        )
                }
            }
            
            // Infos Texte
            VStack(spacing: 4) {
                Text(profilVM.fullName.isEmpty ? "Investisseur" : profilVM.fullName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(profilVM.currentUser.email)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}

// MARK: - Components

/// Bouton large avec gradient pour les actions principales
struct LiquidGradientCardButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(16)
        .background(
            LinearGradient(colors: colors.map { $0.opacity(0.8) }, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: colors.first!.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

/// Ligne d'historique de réponse (Style "Verre")
struct LiquidAnswerRow: View {
    let answer: Answer
    
    var body: some View {
        HStack(spacing: 16) {
            // Icône Catégorie
            ZStack {
                Circle()
                    .fill(.white.opacity(0.05))
                    .frame(width: 40, height: 40)
                
                answer.question.questionGroup.icon.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(answer.question.questionGroup.titlePrefix)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.5))
                    .textCase(.uppercase)
                
                Text(answer.question.label) // ou content si trop long, utiliser .label
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // La réponse (Montant ou texte)
            Text(answer.content)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.cyan)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    UserProfileView()
        .environment(TabViewModel())
}
