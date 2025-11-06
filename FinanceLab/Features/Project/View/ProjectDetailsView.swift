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
    @State private var showAddView: Bool = false
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
                            title: "Durée restante",
                            subtitle: "Ce projet est prévu pour durer",
                            info: "\(project.numberOfMonthsToReachGoal) mois"
                        )
                        ProjectDetailsCardView(
                            title: "Fin",
                            subtitle: "À ce rythme, ce projet sera fini en",
                            info: project.deadlineFormatted
                        )
                    }
                    Button(action: {
                        showAddView.toggle()
                    }, label: {
                        Text("J'ajoute à ma cagnotte")
                    })
                    .buttonStyle(FinanceButton(state: .validate))
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
        .sheet(isPresented: $showAddView) {
            AddAmountSheetView(project: $project) { addedAmount in
                let oldValue = project.amountSaved
                Task {
                    do {
                        print("Le montant que j'envoi est de \(project.amountSaved)")
                        self.project = try await projectVM.updateProject(with: project)
                        print("Le montant que j'e recois est de \(project.amountSaved)")
                    } catch {
                        project.amountSaved = oldValue // rollback
                        projectVM.launchError(withError: error)
                    }
                }
            }
            .presentationDetents([.fraction(0.20)])
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
    var amount: Decimal
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

struct AddAmountSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var project: Project
    @State private var amountText: String = ""
    var onValidate: ((Decimal) -> Void)? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            CustomFieldView(label: "J'ai mis de côté", text: $amountText, placeholder: "0.00 €", state: .amount)
                .keyboardType(.decimalPad)
            Spacer()
            HStack {
                Button("Annuler") {
                    dismiss()
                }
                .buttonStyle(FinanceButton(state: .normal))
                Button("Ajouter") {
                    if let value = decimalFromString(amountText) {
                        project.amountSaved += value
                        onValidate?(value)
                        dismiss()
                    }
                }
                .buttonStyle(FinanceButton(state: .validate))
                .disabled(decimalFromString(amountText) == nil)
            }
        }
        .foregroundStyle(Color.Text.contrasted)
        .padding()
    }
    
    private func decimalFromString(_ text: String) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        if let number = formatter.number(from: text) {
            return number.decimalValue
        }
        return nil
    }
}
