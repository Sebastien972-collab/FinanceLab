//
//  ProjectDetailsView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 05/10/2025.
//

import SwiftUI
import FinanceCore

struct ProjectDetailsView: View {
    var project: Project
    @Environment(ProjectViewModel.self) private var projectVM
    @State var manager: ProjectCreatorManager = .init()
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let imageName = project.iconName {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 300)
                    .opacity(0.15)
                    .offset(x: 125, y: 20)
                    .foregroundStyle(LinearGradient.greenGradient)
                    .padding(.bottom)
                
            }
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("\(project.name)")
                        .font(Font.custom("Host Grotesk", size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.Text.contrasted)
                    StandardCard {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Avancé du projet")
                                    .font(.cardTitle)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.Text.primary)
                                Text("J'ai déja mis de côté")
                                    .font(.cardSubtitle)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.Text.primary)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                AmountView(amount: Decimal(project.progressPercentage), selection: .percent)
                                ProgressView(value: project.progressPercentage)
                                HStack {
                                    AmountView(amount: project.amountSaved)
                                    Spacer()
                                    Text("/" + project.goalAmount.formatted() + " €")
                                        .font(Font.custom("Host Grotesk", size: 12))
                                        .foregroundStyle(Color.Text.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    VStack(alignment: .leading) {
                        Text("Détails")
                            .font(Font.custom("Host Grotesk", size: 18))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.Text.contrasted)
                        ProjectDetailsCardView(title: "Épargne mensuelle", subtitle: "Je mets de côté chaque mois", info: "\(project.monthlyAmount.formatted()) €")
                        ProjectDetailsCardView(title: "Durée", subtitle: "Ce projet dure depuis", info: "\(project.numberOfMonthsToReachGoal) mois ")
                        ProjectDetailsCardView(title: "Fin", subtitle: "À ce rythme, ce projet sera fini en", info: project.deadlineFormatted)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $manager.isEditing, destination: {
                ProjectCreatorView(projectManager: manager)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        manager.manager = projectVM
                        manager.update(project: project)
                    } label: {
                        Text("Modifier")
                            .frame(width: 120, height: 44)
                            .background {
                                Capsule()
                                    .foregroundStyle(LinearGradient.greenGradient)
                            }
                            .buttonStyle(.plain)
                    }
        
                    
                    
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // contrôle la visibilité, mais avec .clear comme matériau
        }
        .background {
            FinancialBackground()
                .ignoresSafeArea(.all)
        }
        
    }
}

#Preview {
    NavigationStack {
        ProjectDetailsView(project: .preview)
            .environment(ProjectViewModel())
    }
}


fileprivate struct AmountView: View {
    let amount: Decimal
    enum Selection: String {
        case eur = "€"
        case percent = "%"
    }
    
    var size: CGFloat = 32
    var selection: Selection = .eur
    var body: some View {
        HStack(spacing: 2) {
            // On convertit et formate correctement selon le type
            let displayedText: String = {
                switch selection {
                case .eur:
                    amount.formatted(.currency(code: "EUR"))
                case .percent:
                    "\(decimalToInt(amount))"
                }
            }()
            Text(LocalizedStringResource(stringLiteral: displayedText))
                .font(Font.custom("Host Grotesk", size: size))
                .fontWeight(.bold)
                .foregroundStyle(Color.Text.primary)
            Text(selection.rawValue)
                .font(Font.custom("Host Grotesk", size: size - 4))
                .fontWeight(.bold)
                .foregroundStyle(Color.Text.primary)
        }
    }
    
    /// Conversion sécurisée Decimal → Int
    private func decimalToInt(_ value: Decimal) -> Int {
        var decimal = value
        var result = Decimal()
        // On arrondit à 0 décimales, mode .plain = arrondi classique (0.5 → 1)
        NSDecimalRound(&result, &decimal, 0, .plain)
        return NSDecimalNumber(decimal: result).intValue
    }
}
