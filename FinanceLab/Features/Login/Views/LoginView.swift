//
//  LoginView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 16/10/2025.
//

import SwiftUI


struct LoginView: View {
    @State var loginVM = LoginViewModel()
    @Binding var authState: AuthState
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
                ], selected: $loginVM.pickerSelected)
                Spacer()
                VStack(spacing: 16) {
                    if loginVM.pickerSelected == 1 {
                        HStack {
                            TextField("Prénom", text: $loginVM.firstName)
                                .textFieldStyle(CustomTextFieldStyle(style: .login))
                            TextField("Nom", text: $loginVM.lastName)
                                .textFieldStyle(CustomTextFieldStyle(style: .login))
                        }
                    }
                    TextField("Adresse email", text: $loginVM.email)
                        .textFieldStyle(CustomTextFieldStyle(style: .login))
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    SecureField("Mot de passe", text: $loginVM.password)
                        .textFieldStyle(CustomTextFieldStyle(style: .login))
                    if loginVM.pickerSelected == 1 {
                        SecureField("Confirmation du mot de passe", text: $loginVM.passwordConfirmation)
                            .textFieldStyle(CustomTextFieldStyle(style: .login))
                    }
                }
                Spacer()
                switch loginVM.pickerSelected {
                        case 0:
                            Button("Se connecter") {
                                Task {
                                    await loginVM.login {
                                        self.authState = .authenticated
                                    }
                                }
                            }
                            .buttonStyle(FinanceButton(state: .validate))
                        case 1:
                            Button("Créer un compte") {
                                Task {
                                    await loginVM.create {
                                        self.authState = .authenticated
                                    }
                                }
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
            .alert("Error", isPresented: $loginVM.showError) {
                Button {} label: {
                    Text("Ok")
                }
            } message: {
                Text(loginVM.error.localizedDescription)
            }
        }
    }
}

#Preview {
    LoginView(authState: .constant(.loading))
}
