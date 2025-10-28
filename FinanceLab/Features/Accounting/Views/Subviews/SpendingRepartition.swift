//
//  SpendingRepartition.swift
//  FinanceLab
//
//  Created by Anne Ferret on 02/10/2025.
//

import SwiftUI

struct SpendingRepartition: View {
    @Binding var spent: Double
    @Binding var gained: Double
    
    var percentage: Double {
        guard gained > 0 else { return 0 }
        guard spent > 0 else { return 1 }
        return spent / (gained + spent)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            PercentageSlider(percentage: percentage, height: .big, color: .redToGreen)
                .id(percentage)
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Text("-")
                        Text(spent.description.split(separator: ".")[0])
                            .font(.listLargeNumber)
                        Text(",")
                        Text(String(spent.description.split(separator: ".")[1].prefix(2)))
                        Text("€")
                    }
                    .font(.listNumber)
                    Text("Dépenses")
                        .font(.cardCallout)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: 2) {
                        Text("+")
                        Text(gained.description.split(separator: ".")[0])
                            .font(.listLargeNumber)
                        Text(",")
                        Text(String(gained.description.split(separator: ".")[1].prefix(2)))
                        Text("€")
                    }
                    .font(.listNumber)
                    Text("Recettes")
                        .font(.cardCallout)
                }
            }
        }
        .foregroundStyle(Color.Text.contrasted)
    }
}

#Preview {
    @Previewable @State var spent: Double = 800.24028
    @Previewable @State var gained: Double = 2000
    
    SpendingRepartition(spent: $spent, gained: $gained)
        .padding()
        .background {
            FinancialBackground().ignoresSafeArea()
        }
}
