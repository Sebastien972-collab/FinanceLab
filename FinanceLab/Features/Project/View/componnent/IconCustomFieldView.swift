//
//  IconCustomFieldView.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 08/10/2025.
//

import SwiftUI

struct IconCustomFieldView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selected: CategoryIcon
    var body: some View {
        NavigationLink {
            ListIconView(selected: $selected)
        } label: {
            VStack(alignment: .leading) {
                Text("Icône")
                    .font(Font.inputFieldText)
                ZStack {
                    Color.Card.background.opacity(0.5)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    selected.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 16)
                        .font(Font.inputFieldText)
                }
            }
        }
        
    }
}



#Preview {
    NavigationStack {
        IconCustomFieldView(selected: .constant(.airplaneTiltFill))
    }
}
