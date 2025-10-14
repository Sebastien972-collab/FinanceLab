//
//  UserCardProfile.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import SwiftUI

struct UserCardProfile: View {
    let user: User
    var body: some View {
        StandardCard {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    UserCardProfile(user: .init(firstName: "Sébastien", lastName: "DAGUIN", email: "hello@world.com", dateOfRegistration: .init(), balance: 0))
}
