//
//  UserExtension.swift
//  FinanceLab
//
//  Created by Dembo on 01/10/2025.
//

import Foundation


extension User {
    
    
    static var userDatabase: [User] {
        let users = [
            User(
                   firstName: "Alice",
                   lastName: "Dupont",
                   email: "alice.dupont@example.com",
                   profilePictureUrl: URL(string: "https://randomuser.me/api/portraits/women/1.jpg")
               ),
               User(
                   firstName: "Karim",
                   lastName: "Benzaki",
                   email: "karim.benzaki@example.com",
                   profilePictureUrl: URL(string: "https://randomuser.me/api/portraits/men/2.jpg")
               ),
               User(
                   firstName: "Sophie",
                   lastName: "Martin",
                   email: "sophie.martin@example.com",
                   profilePictureUrl: URL(string: "https://randomuser.me/api/portraits/women/3.jpg")
               ),
               User(
                   firstName: "Julien",
                   lastName: "Moreau",
                   email: "julien.moreau@example.com",
                   profilePictureUrl: URL(string: "https://randomuser.me/api/portraits/men/4.jpg")
               ),
               User(
                   firstName: "Clara",
                   lastName: "Lopez",
                   email: "clara.lopez@example.com",
                   profilePictureUrl: URL(string: "https://randomuser.me/api/portraits/women/5.jpg")
               )
        ]
    
        return users
    }
}















//func lkdnaenfc() {
//    let user = User(firstName: "", lastName: "", email: "")
//    print(user.email)
//}
