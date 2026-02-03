//
//  SwipeableCard.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/10/2025.
//

import SwiftUI

struct SwipeableCard<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    let content: () -> Content
    let onDelete: () -> Void
    
    // Seuil de déclenchement
    private let triggerThreshold: CGFloat = -80
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Fond Rouge de suppression (Arrière-plan)
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.red.opacity(0.8))
                
                Image(systemName: "trash.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.trailing, 30)
                    .scaleEffect(offset < triggerThreshold ? 1.2 : 1.0) // Petite animation d'icône
            }
            .opacity(offset < 0 ? 1 : 0) // Visible uniquement si on swipe
            
            // Contenu (Premier plan)
            content()
                .offset(x: offset + translation)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            // On limite le swipe vers la droite (positif)
                            if value.translation.width < 0 {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                if value.translation.width < triggerThreshold {
                                    // Swipe validé -> On supprime
                                    // On décale complètement la carte vers la gauche avant de supprimer
                                    offset = -1000
                                    // Délai pour laisser l'animation de sortie se faire
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onDelete()
                                    }
                                } else {
                                    // Swipe annulé -> Retour à 0
                                    offset = 0
                                }
                            }
                        }
                )
        }
    }
}


import FinanceCore
#Preview {
    SwipeableCard {
        NavigationLink {
            Text("Détails du projet")
        } label: {
            ProjectCard(project: Project.preview)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
    } onDelete: {
        
    }.background {
        FinancialBackground()
            .ignoresSafeArea(.all)
    }
}
