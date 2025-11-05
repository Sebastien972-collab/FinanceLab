//
//  ProjectsView.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 01/10/2025.
//

import SwiftUI
import FinanceCore

struct ProjectsView: View {
    @Environment(ProjectViewModel.self) private var projectVM
    @State private var selectedProject: Project? = nil
    @State private var projectCreatorVM: ProjectCreatorViewModel = .init()
    @State private var isLoading: Bool = true
    var body: some View {
        NavigationStack {
            @Bindable var projectVM = projectVM
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Mes projets")
                        .font(.title)
                    if isLoading {
                        VStack (alignment: .center) {
                            ProgressView()
                        }
                    } else {
                    if projectVM.projects.isEmpty {
                        DemboCard {
                            Text("Crée ton premier projet dès maintenant et commence à économiser !")
                        }
                        .onTapGesture {
                            projectCreatorVM.manager = projectVM
                            projectCreatorVM.isEditing.toggle()
                        }
                    } else {
                        VStack(spacing: 16) {
                            ForEach(projectVM.projects) { project in
                                SwipeableCard {
                                    ProjectCard(project: project)
                                        .frame(maxWidth: .infinity)
                                        .onTapGesture {
                                            projectCreatorVM.manager = projectVM
                                            selectedProject = project
                                        }
                                } onDelete: {
                                    Task {
                                        await projectVM.remove(project)
                                    }
                                }
                            }
                        }
                    }
                    }
                    Button("Démarrer un nouveau projet") {
                        projectCreatorVM.manager = projectVM
                        projectCreatorVM.isEditing.toggle()
                    }
                    .buttonStyle(FinanceButton(state: .validate))
                }
                .font(.body)
                .foregroundStyle(Color.Text.contrasted)
                .padding()
            }
            .task {
                await projectVM.fetchProjects()
                isLoading = false
            }
            .alert("Error", isPresented: $projectVM.showError) {
                Button {} label: {
                    Text("Ok")
                }
            } message: {
                Text(projectVM.error.localizedDescription)
            }
            .background {
                FinancialBackground()
                    .ignoresSafeArea(.all)
            }
            .sheet(isPresented: $projectCreatorVM.isEditing) {
                ProjectCreatorView(projectManager: projectCreatorVM, action: {
                    Task {
                        await projectVM.fetchProjects()
                    }
                })
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
            .navigationDestination(item: $selectedProject) { project in
                ProjectDetailsView(project: project)
            }
        }
    }
}


#Preview {
    ProjectsView()
        .environment(ProjectViewModel())
}
