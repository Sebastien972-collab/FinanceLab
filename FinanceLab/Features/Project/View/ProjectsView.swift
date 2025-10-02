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
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    ForEach(projectVM.projects) { project in
                        NavigationLink {
                            Text("Détails du projet \(project.name)")
                        } label: {
                            ProjectCard(project: project)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }

                    }
                    .padding(.bottom)
                    ContinuButtonView(title: "+ Démarrer un nouveau projet", state: .validate) {
                        projectVM.creatorMode.toggle()
                    }
                }
                .navigationTitle(Text("Mes Projects"))
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
        }
    }
}

#Preview {
    ProjectsView()
}
