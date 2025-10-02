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
    
    enum InputField {
    case name, goalAmount, goalDate
    }
    @FocusState private var selection: InputField?
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    CustomFieldView(label: "Nom du projet", text: $projectManager.name, state: .project)
                        .focused($selection, equals: .name)
                        .submitLabel(.next)
                        .onSubmit {
                            selection = .goalAmount
                        }
                    IconCustomField()
                        .padding(.trailing)
                }
                HStack {
                    CustomFieldView(label: "Coût total du projet", text: $projectManager.stringGoalAmount, state: .project)
                        .keyboardType(.decimalPad)
                        .focused($selection, equals: .goalAmount)
                        .submitLabel(.send)
                        .onSubmit {
                            projectManager.recalculator()
                        }
                    CustomFieldView(label: "Date de fin de projet", text: $projectManager.stringGoalAmount, state: .project)
                    
                }
                Spacer()
                
                VStack {
                    ContinuButtonView(title: "Calculer", state: .normal, action: projectManager.recalculator)
                    ContinuButtonView(title: "Valider", state: .validate, action: projectManager.validate)
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
                            Text("Ok")
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
        }
    }
}

#Preview {
    NavigationStack {
        ProjectCreatorView()
    }
}

fileprivate struct IconCustomField: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Icône")
                .font(Font.inputFieldText)
            Button {
            } label: {
                ZStack {
                    Color.Card.background.opacity(0.5)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 16)
                        .font(Font.inputFieldText)
                }
            }
        }
    }
}
