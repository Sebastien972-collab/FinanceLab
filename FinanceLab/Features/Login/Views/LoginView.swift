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
    @State var passwordConfirmation: String = ""
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
                    if pickerSelected == 1 {
                        HStack {
                            TextField("Prénom", text: $firstName)
                                .textFieldStyle(CustomTextFieldStyle(style: .login))
                            TextField("Nom", text: $lastName)
                                .textFieldStyle(CustomTextFieldStyle(style: .login))
                        }
                    }
                    TextField("Adresse email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle(style: .login))
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(CustomTextFieldStyle(style: .login))
                    if pickerSelected == 1 {
                        SecureField("Confirmation du mot de passe", text: $passwordConfirmation)
                            .textFieldStyle(CustomTextFieldStyle(style: .login))
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
                                    passwordConfirmation: passwordConfirmation,
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
