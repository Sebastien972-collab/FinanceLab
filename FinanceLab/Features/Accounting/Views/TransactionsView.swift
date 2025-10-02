//
//  TransactionsView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct TransactionsView: View {
    @State var pickerSelected = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Septembre 2025")
                        .font(.title)
                    FinancialPicker(options: ["Dépenses et recettes", "Par catégories"], selected: $pickerSelected)
                }
                switch pickerSelected {
                    case 0: SpendingRepartition(amountSpent: 1000.12, amountGained: 2200.22)
                    default: EmptyView()
                }
            }
            .foregroundStyle(Color.Text.contrasted)
            .padding(.horizontal)
        }
        .background {
            FinancialBackground().ignoresSafeArea()
        }
    }
}

#Preview {
    TransactionsView()
}
