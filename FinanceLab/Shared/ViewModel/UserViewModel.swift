////
////  UserViewModel.swift
////  FinanceLab
////
////  Created by Sébastien DAGUIN on 14/10/2025.
////
//
//import SwiftUI
//
//@Observable
//class UserViewModel {
//    var manager: UserManager = .init()
//    var currentUser: User = .guest
//    var error: Error?
//    var showError = false
//    var isAuth: Bool {
//        currentUser != .guest
//    }
//    
//    
//    func create(email: String, password: String) async throws {
//        do {
//            self.currentUser =  try await  manager.create(email: email , password: password)
//        } catch  {
//            self.error = error
//            self.showError.toggle()
//        }
//    }
//    func login(email: String, password: String) async throws {
//        do {
//            self.currentUser = try await manager.login(email: email , password: password)
//        } catch  {
//            self.error = error
//            self.showError.toggle()
//        }
//    }
//    
//    func updateUser() {
//        manager.upadateUser(currentUser)
//    }
//    
//    func logout() {
//        self.currentUser = .guest
//    }
//    
//}
