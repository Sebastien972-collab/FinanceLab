//
//  OnboardingSteps.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/09/2025.
//

import SwiftUI

class OnboardingFlow {
    var currentStep: Int = 0

    let steps: [OnboardingStep] = [
        OnboardingStep(
            icon: "hand.wave.fill", title: "Bienvenue !",
            content: "Cette application va te permettre de te familiariser avec la notion de **santé financière**, et de mieux gérer ton budget au quotidien." // Était: hand-waving-fill
        ),
        OnboardingStep(
            icon: "chart.pie.fill", title: "Budget",
            content: "Suis ton argent au jour le jour et découvre ton **indice de santé financière** : un indicateur clair pour savoir si tu gères bien ton budget."
        ),
        OnboardingStep(
            icon: "target", title: "Projets",
            content: "Crée des **projets d’épargne** réalistes : envie d'une nouvelle console ? Besoin d'une voiture ? Choisis un objectif et concrétise-le." // Était: calendar-check-fill
        ),
        OnboardingStep(
            icon: "party.popper.fill", title: "Dépenses",
            content: "Retrouve ton **reste à t’amuser** — le montant que tu peux dépenser aujourd’hui pour profiter sans mettre tes finances en danger !"
        ),
        OnboardingStep(
            icon: "book.pages.fill", title: "S'informer",
            content: "Explore des **articles et conseils** simples pour renforcer ta santé financière, avec un glossaire pour décoder les termes compliqués."
        ),
    ]
}
