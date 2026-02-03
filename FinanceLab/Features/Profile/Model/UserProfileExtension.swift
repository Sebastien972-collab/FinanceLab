//
//  UserExtension.swift
//  FinanceLab
//
//  Created by Dembo on 01/10/2025.
//

import Foundation


extension Customer {
    static var userDatabase: [Customer] {
        let users = [
            Customer(
                firstName: "Alice",
                lastName: "Dupont",
                email: "alice.dupont@example.com",
                profilePictureUrl: "https://randomuser.me/api/portraits/women/1.jpg"
            ),
            Customer(
                firstName: "Karim",
                lastName: "Benzaki",
                email: "karim.benzaki@example.com",
                profilePictureUrl: "https://randomuser.me/api/portraits/men/2.jpg"
            ),
            Customer(
                firstName: "Sophie",
                lastName: "Martin",
                email: "sophie.martin@example.com",
                profilePictureUrl:  "https://randomuser.me/api/portraits/women/3.jpg"
            ),
            Customer(
                firstName: "Julien",
                lastName: "Moreau",
                email: "julien.moreau@example.com",
                profilePictureUrl:  "https://randomuser.me/api/portraits/men/4.jpg"
            ),
            Customer(
                firstName: "Clara",
                lastName: "Lopez",
                email: "clara.lopez@example.com",
                profilePictureUrl:  "https://randomuser.me/api/portraits/women/5.jpg"
            )
        ]
        
        return users
    }
}















//func lkdnaenfc() {
//    let user = User(firstName: "", lastName: "", email: "")
//    print(user.email)
//}
