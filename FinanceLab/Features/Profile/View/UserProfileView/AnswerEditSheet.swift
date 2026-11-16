//
//  AnswerEditSheet.swift
//  FinanceLab
//
//  Created by Codex on 20/03/2026.
//

import SwiftUI

struct AnswerEditSheet: View {
    let answer: Answer
    let onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var value: String
    @FocusState private var isFocused: Bool
    @State private var errorMessage: String?

    init(answer: Answer, onSave: @escaping (String) -> Void) {
        self.answer = answer
        self.onSave = onSave
        _value = State(initialValue: answer.content)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LiquidMeshBackground()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text(answer.question.label)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    LiquidQuestionInputField(question: answer.question, text: $value)
                        .focused($isFocused)

                    Button {
                        do {
                            try validate(value)
                            onSave(value)
                            dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    } label: {
                        Text("Enregistrer")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    }
                    .disabled(value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(24)
            }
            .navigationTitle("Modifier")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") {
                        isFocused = false
                    }
                }
            }
            .onAppear {
                isFocused = true
            }
            .alert("Valeur invalide", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func validate(_ rawValue: String) throws {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw LoginError.custom("Entre une valeur pour enregistrer la modification.")
        }

        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")

        switch answer.question.inputKind {
        case .currency:
            guard let amount = Decimal(string: normalized), amount >= 0 else {
                throw LoginError.custom("Entre un montant valide.")
            }
        case .count, .years:
            guard let value = Double(normalized), value >= 0 else {
                throw LoginError.custom("Entre un nombre valide.")
            }
        case .percentage:
            guard let value = Decimal(string: normalized), value >= 0, value <= 100 else {
                throw LoginError.custom("Entre un pourcentage entre 0 et 100.")
            }
        }
    }
}
