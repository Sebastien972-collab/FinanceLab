//
//  ProjectCreatorView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 02/10/2025.
//

import SwiftUI

struct ProjectCreatorView: View {
    @State var projectManager: ProjectCreatorManager = .init()
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false
    private enum InputField {
        case name, goalAmount, goalDate
    }
    @FocusState private var selection: InputField?
    
    var body: some View {
        NavigationStack {
            VStack {
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
                            ZStack {
                                FinancialBackground()
                                    .ignoresSafeArea(.all)
                                DatePicker("Date de fin de projet", selection: $projectManager.finalDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                            }
                        }
                }
                Spacer()
                VStack {
                    ContinueButtonView(title: "Calculer", state: .normal) {
                        projectManager.recalculator(1000)
                    }
                    ContinueButtonView(title: "Valider", state: .validate, action: projectManager.validate)
                }
            }
            .background(content: {
                FinancialBackground()
                    .ignoresSafeArea(edges: .all)
            })
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
                ToolbarItem(placement: .principal) {
                    Text("Mon projet")
                        .font(.buttonLabel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        projectManager.reset {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(LinearGradient.redGradient)
                    }
                }
            }
            .alert("Error", isPresented: $projectManager.showError) {
                Button {
                    
                } label: {
                    Text("Ok")
                }
                
            } message: {
                Text(projectManager.error.localizedDescription)
            }
            
            
        }
    }
}

#Preview {
    NavigationStack {
        ProjectCreatorView()
    }
}

