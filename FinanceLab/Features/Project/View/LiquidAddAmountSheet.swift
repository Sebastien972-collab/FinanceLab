import SwiftUI
import FinanceCore

struct LiquidAddAmountSheet: View {
    let project: Project
    var onSave: (Decimal, UUID) async throws -> Void
    @State private var operationID = UUID()
    @State private var isSaving = false
    @State private var errorMessage = ""
    @State private var showError = false

    @Environment(\.dismiss) var dismiss
    @State private var amountText = ""
    @FocusState private var isFocused: Bool

    // Animation pour le fond liquide
    @State private var animateBackground = false

    // Calcul du montant restant pour atteindre l'objectif du projet
    private var remainingAmount: Decimal {
        max(0, project.goalAmount - project.amountSaved)
    }

    // Récupération sécurisée du solde de l'utilisateur
    private var userBalance: Decimal {
        CustomerManager.shared.currentUser.balance
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Fond Liquid Glass
                ZStack {
                    Color.black.ignoresSafeArea()
                    Circle()
                        .fill(Color.blue.opacity(0.5))
                        .frame(width: 350)
                        .blur(radius: 70)
                        .offset(x: animateBackground ? -80 : 80, y: animateBackground ? 150 : -100)

                    Circle()
                        .fill(Color.purple.opacity(0.4))
                        .frame(width: 300)
                        .blur(radius: 60)
                        .offset(x: animateBackground ? 100 : -100, y: animateBackground ? -150 : 150)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                        animateBackground.toggle()
                    }
                }
                .ignoresSafeArea()

                // MARK: - Contenu
                VStack(spacing: 40) {
                    Spacer()

                    VStack(spacing: 24) {
                        // Affichage du montant saisi
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            TextField("0", text: $amountText)
                                .keyboardType(.decimalPad)
                                .focused($isFocused)
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize()

                            Text("€")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.4))
                        }

                        // Bouton de Synchronisation / Info Solde
                        Button {
                            // On synchronise avec le montant restant à épargner
                            amountText = "\(remainingAmount)"
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
                            VStack(spacing: 4) {
                                Label("Objectif restant : \(remainingAmount.formatted()) €", systemImage: "target")
                                Text("Votre solde actuel : \(userBalance.formatted()) €")
                                    .font(.caption2)
                                    .opacity(0.8)
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .foregroundStyle(.blue)
                    }

                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    Button(action: { Task { await saveAmount() } }) {
                        Text("Valider")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background {
                                if amountText.isEmpty {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.05))
                                } else {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue.gradient)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.15), lineWidth: 1)
                            )
                    }
                    .disabled(amountText.isEmpty || isSaving)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    .background(.clear)
                }
            }
            .navigationTitle("Ajouter une épargne")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Annuler") { dismiss() }
                        .foregroundStyle(.white.opacity(0.6))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fermer") {
                        isFocused = false
                    }
                }
            }
            .disabled(isSaving)
            .interactiveDismissDisabled(isSaving)
            .alert("Versement impossible", isPresented: $showError) {
                Button("OK") {}
            } message: { Text(errorMessage) }
            .onAppear { isFocused = true }
        }
        .preferredColorScheme(.dark)
    }

    private func saveAmount() async {
        guard !isSaving else { return }
        let normalized = amountText.replacingOccurrences(of: ",", with: ".")
        guard normalized.range(of: #"^[0-9]+(?:\.[0-9]{1,2})?$"#, options: .regularExpression) != nil,
              let amount = Decimal(string: normalized), amount > 0 else {
            errorMessage = "Saisis un montant positif avec deux décimales au maximum."
            showError = true
            return
        }
        isSaving = true
        defer { isSaving = false }
        do {
            try await onSave(amount, operationID)
            UIImpactFeedbackGenerator().impactOccurred()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    LiquidAddAmountSheet(project: .preview) { _, _ in }
}
