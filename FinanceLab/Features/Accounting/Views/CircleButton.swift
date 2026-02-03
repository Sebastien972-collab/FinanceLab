//
//  CircleButton.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/02/2026.
//

import SwiftUI

struct CircleButton: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}
