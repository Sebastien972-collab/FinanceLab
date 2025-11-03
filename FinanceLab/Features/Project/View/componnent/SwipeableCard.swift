//
//  SwipeableCard.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/10/2025.
//

import SwiftUI

/// Vue réutilisable qui gère le swipe avec DragGesture
struct SwipeableCard<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @State private var offset: CGFloat = 0
    let content: () -> Content
    let onDelete: () -> Void
    
    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> Void) {
        self.content = content
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                if offset == -90 {
                    Button {
                        withAnimation(.spring()) {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .padding(.trailing, 24)
                    .buttonStyle(FinanceButton(state: .cancel, size: .delete))
                }
            }
            
            content()
                .offset(x: offset + translation)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            if value.translation.width < 0 {
                                // limite pour éviter qu’on tire à l’infini
                                state = max(value.translation.width, -120)
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                if value.translation.width < -80 {
                                    offset = -90 // reste ouvert
                                } else {
                                    offset = 0 // revient fermé
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
