//
//  LiquidProjectsView.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 01/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI
import FinanceCore

struct ProjectsView: View {
    @Environment(ProjectViewModel.self) private var projectVM
    
    // UI State
    @State private var selectedProject: Project? = nil
    @State private var projectCreatorVM: ProjectCreatorViewModel = .init()
    @State private var isLoading: Bool = true
    @State private var showCreator = false
    
    var body: some View {
        @Bindable var projectVM = projectVM
        NavigationStack {
            ZStack {
                // 1. Fond Animé
                LiquidMeshBackground()
                    .ignoresSafeArea()
                
                // 2. Contenu
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                } else {
                    mainContent
                }
                
                VStack {
                    Spacer()
                    Button {
                        openCreator()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 60, height: 60)
                                .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .task {
                await projectVM.fetchProjects()
                withAnimation { isLoading = false }
            }
            .sheet(isPresented: $showCreator) {
                ProjectCreatorView(projectManager: projectCreatorVM)
                .presentationDetents([.medium, .large])
                .presentationBackground(.ultraThinMaterial)
            }
            .navigationDestination(item: $selectedProject) { project in
                ProjectDetailsView(project: project)
            }
            .alert("Oups", isPresented: $projectVM.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(projectVM.error.localizedDescription)
            }
        }
    }
    
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // En-tête
                Text("Mes Projets")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)

                if projectVM.projects.isEmpty {
                    emptyState
                } else {
                    projectsSection

                    // Liste des cartes
                    LazyVStack(spacing: 20) {
                        ForEach(projectVM.projects) { project in
                            SwipeableCard {
                                ProjectCard(project: project)
                                    .onTapGesture {
                                        prepareCreator(for: project)
                                    }
                            } onDelete: {
                                delete(project)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100) // Espace pour le FAB
                }

                savingsSection
            }
        }
    }
    
    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 16) {
            projectsSection

            LiquidDemboCard {
                Text("Crée ton premier projet dès maintenant et commence à réaliser tes rêves ! 🚀")
            }
            .padding(.horizontal, 20)
            .onTapGesture {
                openCreator()
            }
        }
    }

    private var savingsPlan: SavingsPlan {
        SavingsPlan.make()
    }

    private var savingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("Épargne")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()

                if savingsPlan.totalRecommended > 0 {
                    Text("\(savingsPlan.totalRecommended.formatted(.number.precision(.fractionLength(0)))) € / mois")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.08))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 24)

            if savingsPlan.pockets.isEmpty {
                LiquidDemboCard {
                    Text("Complète ton profil financier pour afficher les poches d'épargne calculées avec FinanceCore.")
                }
                .padding(.horizontal, 20)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Profil \(savingsPlan.profile.rawValue)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))

                    Text("Solde actuel pris en compte : \(savingsPlan.currentBalance.formatted(.currency(code: "EUR")))")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.65))
                }
                .padding(.horizontal, 24)

                LazyVStack(spacing: 16) {
                    ForEach(savingsPlan.pockets) { pocket in
                        SavingsPocketCard(pocket: pocket)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var projectsSection: some View {
        Text("Mes cagnottes")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
    }

    // MARK: - Actions
    
    private func openCreator() {
        projectCreatorVM.manager = projectVM
        // Reset creator VM if needed
        showCreator = true
    }
    
    private func prepareCreator(for project: Project) {
        projectCreatorVM.manager = projectVM
        selectedProject = project
    }
    
    private func delete(_ project: Project) {
        Task {
            await projectVM.remove(project)
        }
    }
}
#Preview {
    ProjectsView()
}
