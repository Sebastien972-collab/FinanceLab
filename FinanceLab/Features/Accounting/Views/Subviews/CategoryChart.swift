//
//  CategoryChart.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/10/2025.
//

import Charts
import SwiftUI

struct CategoryChart: View {
    @Binding var transactionsChart: [(icon: CategoryIcon, amount: Double)]
    @State var isSpendings: Bool = false
    
    var body: some View {
        Chart(transactionsChart, id: \.icon.id) { item in
        SectorMark(
          angle: .value("Montant", item.amount),
          innerRadius: .ratio(0.6)
        )
          .foregroundStyle(by: .value("Catégorie", item.icon.id))
          .annotation(position: .overlay) {
              VStack {
                  Image(item.icon.resource)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(height: 22)
                  Text("\(item.amount, format: .currency(code: "EUR"))")
              }
              .font(.caption)
              .foregroundStyle(Color.Text.contrasted)
            }
        }
        .chartLegend(.hidden)
        .chartForegroundStyleScale(range: isSpendings
                                   ? Gradient(colors: [Color.Chart.Spendings.start, Color.Chart.Spendings.stop])
                                   : Gradient(colors: [Color.Chart.Gains.start, Color.Chart.Gains.stop]))
        .scaledToFit()
    }
}

#Preview {
    @Previewable @State var transactionsChart: [(icon: CategoryIcon, amount: Double)] = [
        (icon: .ambulanceFill, amount: 400.00),
        (icon: .carrotFill, amount: 20.00),
        (icon: .buildingOfficeFill, amount: 100.00),
        (icon: .cakeFill, amount: 10.38),
    ]
    CategoryChart(transactionsChart: $transactionsChart)
}
