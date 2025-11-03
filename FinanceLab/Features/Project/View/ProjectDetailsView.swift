//
//  ProjectDetailsView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 05/10/2025.
//

import SwiftUI
import FinanceCore

struct ProjectDetailsView: View {
    @State var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(ProjectViewModel.self) private var projectVM
    @State var manager: ProjectCreatorViewModel = .init()
    @State private var updateManager: ProjectUpdateCreator = .init(project: .preview)
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
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(project.name)
                        .font(.title)
                    StandardCard {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Avancée du projet")
                                    .font(.cardTitle)
                                Text("J'ai déja mis de côté")
                                    .font(.cardSubtitle)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                AmountView(amount: Decimal(project.progressPercentage), selection: .percent)
                                PercentageSlider(percentage: project.progressPercentage, color: .greenToRed)
                                HStack {
                                    AmountView(amount: project.amountSaved)
                                    Spacer()
                                    Text("/ " + project.goalAmount.formatted() + " €")
                                        .font(.body)
                                        .foregroundStyle(Color.Text.secondary)
                                }
                            }
                        }
                        .foregroundStyle(Color.Text.primary)
                        .padding()
                    }
                    Text("Dans le détail")
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 16) {
                        ProjectDetailsCardView(
                            title: "Épargne mensuelle",
                            subtitle: "Je mets de côté chaque mois",
                            info: "\(project.monthlyAmount.formatted(.number.precision(.fractionLength(2)))) €"
                        )
                        ProjectDetailsCardView(
                            title: "Durée",
                            subtitle: "Ce projet dure depuis",
                            info: "\(project.numberOfMonthsToReachGoal) mois"
                        )
                        ProjectDetailsCardView(
                            title: "Fin",
                            subtitle: "À ce rythme, ce projet sera fini en",
                            info: project.deadlineFormatted
                        )
                    }
                }
                .foregroundStyle(Color.Text.contrasted)
                .padding()
            }
        }
        .sheet(isPresented: $manager.isEditing) {
            ProjectCreatorView(projectManager: updateManager)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Précédent", systemImage: "chevron.left") {
                    dismiss()
                }
                .buttonStyle(FinanceButton(size: .round))
            }
            .sharedBackgroundVisibility(.hidden)
            ToolbarItem(placement: .confirmationAction) {
                Button("Modifier") {
                    updateManager.manager = projectVM
                    updateManager.setupProject(project)
                    manager.isEditing = true
                }
                .buttonStyle(FinanceButton(state: .validate, size: .mini))
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .navigationBarBackButtonHidden()
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
        HStack(spacing: 4) {
            // On convertit et formate correctement selon le type
            let displayedText: String = {
                switch selection {
                case .eur:
                    amount.formatted(.number.precision(.fractionLength(2)))
                case .percent:
                    "\(decimalToInt(amount))"
                }
            }()
            Text(LocalizedStringResource(stringLiteral: displayedText))
                .font(.cardNumber)
            Text(selection.rawValue)
                .font(.cardCurrency)
                .foregroundStyle(Color.Text.secondary)
        }
        .foregroundStyle(Color.Text.primary)
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
