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
    @State private var projectCreatorVM: ProjectCreatorManager = .init()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    ForEach(projectVM.projects) { project in
                        SwipeableCard {
                            ProjectCard(project: project)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .onTapGesture {
                                    projectCreatorVM.manager = projectVM
                                    selectedProject = project
                                }
                        } onDelete: {
                            projectVM.remove(project)
                        }
                    }
                    .padding(.bottom)
                    
                    ContinuButtonView(title: "+ Démarrer un nouveau projet", state: .validate) {
                        projectCreatorVM.manager = projectVM
                        projectCreatorVM.isEditing.toggle()
                    }
                }
                .navigationTitle(Text("Mes Projets"))
                .onAppear {
                   
                }
            }
            .background {
                FinancialBackground()
                    .ignoresSafeArea(.all)
            }
            .sheet(isPresented: $projectCreatorVM.isEditing) {
                ProjectCreatorView(projectManager: projectCreatorVM)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
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
