//
//  ListIconView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 08/10/2025.
//

import SwiftUI

struct ListIconView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selected: CategoryIcon
    
    private let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Icône du projet")
                    .font(.title2.bold())
                    .foregroundStyle(Color.Text.primary)
                    .padding(.top)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(CategoryIcon.allCases) { icon in
                        icon.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(selected == icon ? Color.accentColor.opacity(0.2) : .clear)
                            )
                            .overlay(
                                Circle()
                                    .stroke(selected == icon ? Color.accentColor : .clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                selected = icon
                                dismiss()
                            }
                    }
                }
                .padding()
            }
        }
        .background {
            FinancialBackground()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ListIconView(selected: .constant(.airplaneTiltFill))
}
