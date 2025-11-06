//
//  ProjectCreatorView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//

import SwiftUI

struct ProjectCreatorView: View {
    @State var projectManager: ProjectCreatorViewModel = .init()
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false
    private enum InputField {
        case name, goalAmount, goalDate
    }
    @FocusState private var selection: InputField?
    
    var action: (() -> Void)? = nil
    
    var body: some View {
        NavigationStack {
                VStack(spacing: 24) {
                    HStack {
                        CustomFieldView(label: "Nom du projet", text: $projectManager.name, placeholder: "Le nom de mon projet", state: .project)
                            .focused($selection, equals: .name)
                            .submitLabel(.next)
                            .onSubmit {
                                selection = .goalAmount
                            }
                        IconCustomFieldView(selected: $projectManager.selectedIcon)
                            .padding(.trailing)
                    }
                    HStack {
                        CustomFieldView(label: "Coût total du projet", text: $projectManager.stringGoalAmount, placeholder: "Ex: 10 000", state: .project)
                            .keyboardType(.decimalPad)
                            .focused($selection, equals: .goalAmount)
                            .submitLabel(.send)
                            .onSubmit {
                                projectManager.recalculator(100)
                            }
                        CustomFieldView(label: "Date de fin de projet", text: .constant(projectManager.finalDateFormatted), state: .project)
                            .disabled(true)
                            .onTapGesture {
                                isPresented.toggle()
                            }
                            .navigationDestination(isPresented: $isPresented) {
                                ScrollView {
                                    DatePicker("Date de fin de projet", selection: $projectManager.finalDate, displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                        .padding()
                                }
                                .presentationDetents([.medium, .large])
                            }
                    }
                    Spacer()
                    Button("Valider") {
                        Task {
                            await projectManager.validate(callback: action)
                        }
                    }
                    .buttonStyle(FinanceButton(state: .validate))
                }
                .foregroundStyle(Color.Text.primary)
                .font(.body)
                .padding(24)
            }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if selection != nil {
                    Button {
                        selection = nil
                    } label: {
                        Text("OK")
                            .font(.buttonLabel)
                    }
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button("Supprimer", image: .trashFill) {
                    projectManager.reset {
                        dismiss()
                    }
                }
                .buttonStyle(FinanceButton(state: .cancel, size: .round))
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .alert("Error", isPresented: $projectManager.showError) {
            Button {} label: {
                Text("Ok")
            }
        } message: {
            Text(projectManager.error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        ProjectCreatorView()
    }
}

