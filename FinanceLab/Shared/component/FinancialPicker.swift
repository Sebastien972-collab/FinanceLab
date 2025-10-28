//
//  FinancialPicker.swift
//  FinanceLab
//
//  Created by Anne Ferret on 25/09/2025.
//

import SwiftUI

/// How to use
///
/// FinancialPicker() uses:
/// - an "options" array of Strings with clear text choices shown to the user
/// - a "selected" Int that defines which index in the array is selected
///
/// Call FinancialPicker() and pass it both parameters, ie.
/// FinancialPicker(options: ["Choix 1", "Choix 2"], selected: $selected)
///
/// In the parent view, you can then use the value of "selected" in a switch to
/// See the FinancialPickerExample() provided as a how-to-use example below.

struct FinancialPicker: View {
    var options : [String] = []
    var isTransaction: Bool = false
    @Binding var selected : Int
        
    var body: some View {
        if #available(iOS 26.0, *) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: options.count)) {
                ForEach(options.enumerated(), id: \.element) { index, choice in
                    Button(action: {
                        selected = index
                    }) {
                        HStack {
                            Spacer()
                            Text(choice)
                            Spacer()
                        }
                        .frame(height: 34)
                        .background(
                            selected == index
                                ? (isTransaction && index == 0 ? LinearGradient.redGradient : LinearGradient.greenGradient)
                                : LinearGradient.clearGradient
                        )
                        .foregroundStyle(
                            selected == index
                                ? Color.Text.primary
                                : Color.Text.contrasted
                        )
                        .font(.system(size: 12))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                }
            }
            .padding(4)
            .background(Color.Segmented.background)
            .cornerRadius(50)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct FinancialPickerExample: View {
    @State var selected : Int = 0

    var body: some View {
        VStack {
            FinancialPicker(options: ["Choix 1", "Choix 2", "Choix 3"], selected: $selected)
            switch selected {
                case 0: Text("FinancialPickerView - Vue 1")
                case 1: Text("FinancialPickerView - Vue 2")
                case 2: Text("FinancialPickerView - Vue 3")
                default: Text("Error")
            }
        }
    }
}

#Preview {
    FinancialPickerExample()
}
