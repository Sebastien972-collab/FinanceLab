//
//  LiquidProjectDetailsView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 05/10/2025.
//  Redesigned by Gemini (Liquid UI Expert) 2026
//

import SwiftUI
import FinanceCore

struct ProjectDetailsView: View {
    @State var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(ProjectViewModel.self) private var projectVM
    
    @State private var creatorVM = ProjectCreatorViewModel()
    @State private var showAddAmountSheet = false
    @State private var showEditSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidMeshBackground()
                    .ignoresSafeArea()
                if let iconName = project.iconName, let icon = CategoryIcon(rawValue: iconName) {
                    Image(icon.resource)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .blur(radius: 60) // Effet de lueur diffuse
                        .opacity(0.3)
                        .offset(x: 100, y: -200)
                }
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Projet")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                                .textCase(.uppercase)
                            
                            Text(project.name)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        ProgressCardView(progressPercentage: project.progressPercentage, amountSaved: project.amountSaved, goalAmount: project.goalAmount)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            LiquidDetailCard(title: "Épargne/Mois", value: "\(project.monthlyAmount.formatted(.number.precision(.fractionLength(0)))) €", icon: "calendar")
                            LiquidDetailCard(title: "Restant", value: "\(project.numberOfMonthsToReachGoal) mois", icon: "hourglass")
                            LiquidDetailCard(title: "Objectif", value: project.deadlineFormatted, icon: "flag.checkered")
                            LiquidDetailCard(title: "Montant", value: "\(project.goalAmount.formatted(.number.notation(.compactName))) €", icon: "target")
                        }
                        .padding(.horizontal, 24)
                        
                        // Bouton Action Principal
                        Button {
                            showAddAmountSheet = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                                
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Ajouter à ma cagnotte")
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 18, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.vertical, 16)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button { dismiss() } label: {
                        CircleButton(icon: "chevron.left")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        creatorVM.manager = projectVM
                        creatorVM.setupForEditing(project: project)
                        showEditSheet = true
                    } label: {
                        CircleButton(icon: "pencil")
                    }
                }
            }
            // Sheet Ajout Montant
            .sheet(isPresented: $showAddAmountSheet) {
                LiquidAddAmountSheet(project: project) { amount, operationID in
                    try await projectVM.contribute(amount, to: project, operationID: operationID)
                    if let updated = projectVM.projects.first(where: { $0.id == project.id }) { project = updated }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
            }
            // Sheet Édition
            .sheet(isPresented: $showEditSheet) {
                ProjectCreatorView(projectManager: creatorVM, action: {
                    // Refresh project data locally
                    if let updated = projectVM.projects.first(where: { $0.id == project.id }) {
                        self.project = updated
                    }
                })
            }
            .presentationDetents([.medium, .large])
            .presentationBackground(.ultraThinMaterial)
        }
    }

}

#Preview {
    ProjectDetailsView(project: Project.preview)
        .environment(ProjectViewModel())
}
