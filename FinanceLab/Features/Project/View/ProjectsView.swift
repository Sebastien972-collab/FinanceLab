//
//  ProjectsView.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 01/10/2025.
//

import SwiftUI
import FinanceCore

struct ProjectsView: View {
    @State private var projectVM: ProjectViewModel = .init()
    @State private var selectedProject: Project? = nil
    
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
                                    selectedProject = project
                                }
                        } onDelete: {
                            projectVM.remove(project)
                        }
                    }
                    .padding(.bottom)
                    
                    ContinuButtonView(title: "+ Démarrer un nouveau projet", state: .validate) {
                        projectVM.creatorMode.toggle()
                    }
                }
                .navigationTitle(Text("Mes Projets"))
                .onAppear {
                    projectVM.fetchProjects()
                }
            }
            .background {
                FinancialBackground()
                    .ignoresSafeArea(.all)
            }
            .sheet(isPresented: $projectVM.creatorMode) {
                ProjectCreatorView(projectManager: projectVM.manager)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .navigationDestination(item: $selectedProject) { project in
                Text("Détail du projet \(project.name)")
            }
        }
    }
}


#Preview {
    ProjectsView()
}
