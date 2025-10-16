//
//  LoginView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 16/10/2025.
//

import SwiftUI


struct LoginView: View {
    @State var loginVM = LoginViewModel()
    
    @State var pickerSelected: Int = 0
    
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                    Image(.mascotWithHalo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                    Image(.serenlyLogotype)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.Text.contrasted)
                        .frame(maxWidth: 120)
                FinancialPicker(options: [
                    "Se connecter",
                    "Créer un compte"
                ], selected: $pickerSelected)
                Spacer()
                VStack(spacing: 16) {
                    HStack {
                        Text("Email")
                        Spacer()
                        TextField("Email", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(maxWidth: 260)
                    }
                    HStack {
                        Text("Mot de passe")
                        Spacer()
                        SecureField("Mot de passe", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(maxWidth: 260)
                    }
                    if pickerSelected == 1 {
                        HStack {
                            Text("Prénom")
                            Spacer()
                            TextField("Prénom", text: $firstName)
                                .textFieldStyle(CustomTextFieldStyle())
                                .frame(maxWidth: 260)
                        }
                        HStack {
                            Text("Nom")
                            Spacer()
                            TextField("Nom", text: $lastName)
                                .textFieldStyle(CustomTextFieldStyle())
                                .frame(maxWidth: 260)
                        }
                    }
                }
                Spacer()
                    switch pickerSelected {
                        case 0:
                            Button("Se connecter") {
                                loginVM.login(email: email, password: password)
                            }
                            .buttonStyle(FinanceButton(state: .validate))
                        case 1:
                            Button("Créer un compte") {
                                loginVM.create(
                                    email: email,
                                    password: password,
                                    firstName: firstName,
                                    lastName: lastName
                                )
                            }
                            .buttonStyle(FinanceButton(state: .validate))
                        default: EmptyView()
                }
            }
            .font(.inputFieldLabel)
            .foregroundStyle(Color.Text.contrasted)
            .padding()
            .padding(.top, 24)
            .background {
                FinancialBackground().ignoresSafeArea()
            }
        }
    }
}

#Preview {
    LoginView()
}
