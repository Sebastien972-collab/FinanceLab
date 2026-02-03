//
//  LiquidTransactionRow.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/02/2026.
//


import SwiftUI
/// Ligne de transaction redesignée
struct LiquidTransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            // Icône Catégorie
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                
                Image(transaction.iconName.rawValue)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            
            // Infos
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(transaction.iconName.name)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Montant
            Text(transaction.amount.formatted(.currency(code: "EUR")))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(transaction.amount > 0 ? Color.green : Color.white)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
