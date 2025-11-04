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
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName, lastName, email, password, confirmPassword
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                
                Image(.mascotWithHalo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                    .scaleEffect(loginVM.pickerSelected == 1 ? 1.02 : 1.0)
                    .animation(.spring(response: 0.45, dampingFraction: 0.8), value: loginVM.pickerSelected)
                
                Image(.serenlyLogotype)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.Text.contrasted)
                    .frame(maxWidth: 120)
                    .opacity(loginVM.pickerSelected == 1 ? 0.95 : 1)
                    .animation(.easeInOut(duration: 0.25), value: loginVM.pickerSelected)
                
                FinancialPicker(options: [
                    "Se connecter",
                    "Créer un compte"
                ], selected: $loginVM.pickerSelected)
                .animation(.spring(response: 0.35, dampingFraction: 0.9), value: loginVM.pickerSelected)
                
                Spacer()
                
                VStack(spacing: 16) {
                    
                    // SIGNUP - name fields
                    if loginVM.pickerSelected == 1 {
                        HStack {
                            TextField("Prénom", text: $loginVM.firstName)
                                .textFieldStyle(CustomTextFieldStyle(style: .login))
                                .focused($focusedField, equals: .firstName)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .lastName }
                            
                            TextField("Nom", text: $loginVM.lastName)
                                .textFieldStyle(CustomTextFieldStyle(style: .login))
                                .focused($focusedField, equals: .lastName)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .email }
                        }
                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                    }
                    
                    // Email
                    TextField("Adresse email", text: $loginVM.email)
                        .textFieldStyle(CustomTextFieldStyle(style: .login))
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                    
                    // Password
                    SecureField("Mot de passe", text: $loginVM.password)
                        .textFieldStyle(CustomTextFieldStyle(style: .login))
                        .focused($focusedField, equals: .password)
                        .submitLabel(loginVM.pickerSelected == 0 ? .go : .next)
                        .onSubmit {
                            if loginVM.pickerSelected == 0 {
                                Task { await login() }
                            } else {
                                focusedField = .confirmPassword
                            }
                        }
                    if !loginVM.password.isEmpty {
                        HStack {
                            Text("Sécurité du mot de passe : \(loginVM.passwordStrength.rawValue)")
                                .font(.footnote)
                                .foregroundStyle(loginVM.passwordStrength.color)
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.98)), removal: .opacity))
                        .animation(.easeInOut(duration: 0.2), value: loginVM.password)
                    }
                    
                    // Confirmation
                    if loginVM.pickerSelected == 1 {
                        SecureField("Confirmation du mot de passe", text: $loginVM.passwordConfirmation)
                            .textFieldStyle(CustomTextFieldStyle(style: .login))
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.go)
                            .onSubmit { Task { await create() } }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focusedField)
                
                Spacer()
                
                switch loginVM.pickerSelected {
                case 0:
                    Button("Se connecter") {
                        Task { await login() }
                    }
                    .buttonStyle(FinanceButton(state: .validate))
                    .contentShape(Rectangle())
                    .animation(.spring(response: 0.25, dampingFraction: 0.85), value: loginVM.pickerSelected)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                case 1:
                    Button("Créer un compte") {
                        Task { await create() }
                    }
                    .buttonStyle(FinanceButton(state: .validate))
                    .contentShape(Rectangle())
                    .animation(.spring(response: 0.25, dampingFraction: 0.85), value: loginVM.pickerSelected)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
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
                Button("OK", role: .cancel) {}
            } message: {
                Text(loginVM.error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func login() async {
        await loginVM.login {
            self.authState = .authenticated
        }
    }
    
    private func create() async {
        await loginVM.create {
            self.authState = .authenticated
        }
    }
}

enum PasswordStrength: String {
    case veryWeak = "Très faible"
    case weak = "Faible"
    case medium = "Correct"
    case strong = "Solide"
    case veryStrong = "Très solide"
}

extension LoginViewModel {
    var passwordStrength: PasswordStrength {
        let pwd = password
        
        guard pwd.count >= 6 else { return .veryWeak }
        
        var score = 0
        
        if pwd.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "\\d", options: .regularExpression) != nil { score += 1 }
        if pwd.range(of: "[@$#!%*?&._-]", options: .regularExpression) != nil { score += 1 }
        if pwd.count >= 12 { score += 1 }

        switch score {
        case 0...1: return .veryWeak
        case 2: return .weak
        case 3: return .medium
        case 4: return .strong
        default: return .veryStrong
        }
    }
}

extension PasswordStrength {
    var color: Color {
        switch self {
        case .veryWeak: return .red
        case .weak: return .orange
        case .medium: return .yellow
        case .strong: return .green
        case .veryStrong: return Color.green.opacity(0.9)
        }
    }
}

