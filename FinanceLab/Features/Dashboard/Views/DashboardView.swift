//
//  LiquidDashboardView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 01/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI

struct DashboardView: View {
    @State private var dashboardVM: DashboardViewModel = .init()
    @State private var showContent = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fond Animé
                LiquidMeshBackground()
                    .ignoresSafeArea()
                
                // 2. Contenu Défilant
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerView
                            .padding(.top, 10)
                        LiquidBudgetCard(
                            healthScore: dashboardVM.healthScore,
                            monthlyRAS: dashboardVM.monthlyRAS,
                            dailyRAS: dashboardVM.dailyRAS,
                            isLoading: dashboardVM.isLoading
                        )
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                        LiquidDemboCard {
                            Text("Tu t'en sors bien ce mois-ci ! Continue comme ça 🚀")
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        NavigationLink(destination: TransactionListView()) {
                            LiquidGradientButton(title: "Je fais mes comptes", icon: "pencil.line")
                        }
                        .padding(.top, 10)
                        
                        Spacer(minLength: 100) // Espace pour le tab bar éventuel
                    }
                    .padding(.horizontal, 20)
                }
                .refreshable {
                    dashboardVM.setup()
                }
            }
            .onAppear {
                dashboardVM.setup()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
        }
    }
    
    // MARK: - Header
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Date().formatted(.dateTime.weekday(.wide).month().day()).capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                
                Text("Bonjour, \(dashboardVM.userName)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            NavigationLink {
                UserProfileView()
            } label: {
                Circle()
                    .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            }

        }
    }
}

// MARK: - COMPOSANTS UI LIQUIDES

/// 3. Carte Budget (Verre + Indicateurs)
struct LiquidBudgetCard: View {
    var healthScore: Double
    var monthlyRAS: Decimal
    var dailyRAS: Decimal
    var isLoading: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Titre de la carte
            HStack {
                Text("Ma Situation")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
                // Indicateur de santé (Cercle animé)
                HStack(spacing: 6) {
                    Text("Santé")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    HealthRing(score: healthScore)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.bottom, 20)
            
            Divider()
                .background(.white.opacity(0.2))
                .padding(.bottom, 20)
            
            if isLoading {
                ProgressView().tint(.white).padding(20)
            } else {
                // Affichage du RAS (Reste à Survivre)
                VStack(spacing: 8) {
                    Text("Reste à dépenser")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text(monthlyRAS.formatted(.currency(code: "EUR")))
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 0) // Glow effect
                    
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundStyle(.yellow)
                        Text("~ \(dailyRAS.formatted(.currency(code: "EUR"))) / jour")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.1))
                    .cornerRadius(20)
                }
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

/// 4. Carte Dembo (Mascotte)
struct LiquidDemboCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Zone Texte
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.yellow)
                    Text("Conseil du jour")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                }
                
                content
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Mascotte Flottante
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 70, height: 70)
                    .blur(radius: 10)
                
                Image(.mascot) // Assurez-vous d'avoir cet asset, sinon systemName "tortoise.fill"
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
        }
        .padding(20)
        .background(
            LinearGradient(colors: [Color.green.opacity(0.2), Color.blue.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
        )
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

/// 5. Bouton Gradient Liquide
struct LiquidGradientButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
            
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(.vertical, 16)
        }
    }
}

/// 6. Anneau de Santé (Petit indicateur visuel)
struct HealthRing: View {
    var score: Double // entre 0 et 1
    
    var color: Color {
        if score > 0.7 { return .green }
        if score > 0.4 { return .orange }
        return .red
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: score)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
}
