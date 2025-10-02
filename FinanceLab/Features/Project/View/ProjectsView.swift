//
//  ProjectsView.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 01/10/2025.
//

import SwiftUI

struct ProjectsView: View {
    let projectVM: ProjectViewModel = .init()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(projectVM.projects) { project in
                        ProjectCard(project: project)
                    }
                    .padding(.bottom)
                    ContinuButtonView(title: "+ Démarrer un nouveau projet", state: .validate) {}
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
        }
    }
}

#Preview {
    ProjectsView()
}
