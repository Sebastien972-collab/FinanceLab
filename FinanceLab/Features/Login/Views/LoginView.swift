//
//  LiquidLoginView.swift
//  FinanceLab
//
//  Created by Anne Ferret on 16/10/2025.
//
//

import SwiftUI

struct LiquidLoginView: View {
    @State var loginVM = LoginViewModel()
    @Binding var authState: AuthState
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName, lastName, email, password, confirmPassword
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidMeshBackground()
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        Spacer(minLength: 40)
                        heroSection
                            .padding(.bottom, 40)
                        VStack(spacing: 25) {
                            LiquidSegmentControl(selectedIndex: $loginVM.pickerSelected)
                                .padding(.bottom, 10)
                            formFields
                            actionButton
                                .padding(.top, 10)
                        }
                        .padding(24)
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Terminer") { focusedField = nil }
                            .tint(.primary)
                    }
                }
            }
            .alert("Oups !", isPresented: $loginVM.showError) {
                Button("Réessayer", role: .cancel) {}
            } message: {
                Text(loginVM.error.localizedDescription)
            }
        }
    }
    
    // MARK: - Sections Visuelles
    
    private var heroSection: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Image(.mascotWithHalo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 130)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .scaleEffect(loginVM.pickerSelected == 1 ? 1.05 : 1.0)
            .animation(.bouncy(duration: 0.6), value: loginVM.pickerSelected)
            
            Image(.serenlyLogotype)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 16) {
            // Animation de transition pour les champs d'inscription
            if loginVM.pickerSelected == 1 {
                HStack(spacing: 12) {
                    LiquidTextField(placeholder: "Prénom", text: $loginVM.firstName, icon: "person")
                        .focused($focusedField, equals: .firstName)
                        .onSubmit { focusedField = .lastName }
                    
                    LiquidTextField(placeholder: "Nom", text: $loginVM.lastName, icon: nil)
                        .focused($focusedField, equals: .lastName)
                        .onSubmit { focusedField = .email }
                }
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.9)))
            }
            
            LiquidTextField(placeholder: "Email", text: $loginVM.email, icon: "envelope", keyboardType: .emailAddress)
                .focused($focusedField, equals: .email)
                .onSubmit { focusedField = .password }
                .textInputAutocapitalization(.never)
            
            VStack(alignment: .leading, spacing: 6) {
                LiquidTextField(placeholder: "Mot de passe", text: $loginVM.password, icon: "lock", isSecure: true)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        if loginVM.pickerSelected == 0 { Task { await login() } }
                        else { focusedField = .confirmPassword }
                    }
                if loginVM.pickerSelected == 1 && !loginVM.password.isEmpty {
                    LiquidPasswordStrength(strength: loginVM.passwordStrength)
                        .padding()
                        .transition(.opacity)
                }
            }
            
            if loginVM.pickerSelected == 1 {
                LiquidTextField(placeholder: "Confirmation", text: $loginVM.passwordConfirmation, icon: "lock.shield", isSecure: true)
                    .focused($focusedField, equals: .confirmPassword)
                    .onSubmit { Task { await create() } }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: loginVM.pickerSelected)
    }
    
    private var actionButton: some View {
        Button {
            Task {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                loginVM.pickerSelected == 0 ? await login() : await create()
            }
        } label: {
            ZStack {
                // Fond liquide du bouton (Gradient animé)
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                
                HStack {
                    if loginVM.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(loginVM.pickerSelected == 0 ? "Connexion" : "S'inscrire")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .disabled(loginVM.isLoading)
        .scaleEffect(loginVM.isLoading ? 0.98 : 1)
        .animation(.easeInOut, value: loginVM.isLoading)
    }
    
    // MARK: - Actions
    private func login() async {
        await loginVM.login { authState = .authenticated }
    }
    
    private func create() async {
        await loginVM.create { authState = .authenticated }
    }
}

// MARK: - COMPOSANTS LIQUID UI (Le Secret du Design)

/// 1. Le Fond Animé "Lava Lamp"
struct LiquidMeshBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Couleur de fond de base
            Color(hex: "0f0c29").overlay(
                LinearGradient(colors: [Color(hex: "302b63"), Color(hex: "24243e")], startPoint: .top, endPoint: .bottom)
            )
            
            // Orbes lumineuses animées
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.4))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: animate ? -50 : 100, y: animate ? -50 : 50)
                    
                    Circle()
                        .fill(Color.blue.opacity(0.4))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: animate ? 200 : 50, y: animate ? 150 : 300)
                    
                    Circle()
                        .fill(Color.cyan.opacity(0.3))
                        .frame(width: 200, height: 200)
                        .blur(radius: 50)
                        .offset(x: animate ? 50 : 250, y: animate ? 400 : 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

/// 2. Champs de texte "Verre Liquide"
struct LiquidTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 18))
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(.gray.opacity(0.7))
            }
            .foregroundStyle(.primary)
            .keyboardType(keyboardType)
            .autocorrectionDisabled()
            .textInputAutocapitalization(keyboardType == .emailAddress ? .none : .sentences)
        }
        .padding()
        .background(Color.white.opacity(0.5)) // Semi-transparence
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.5), lineWidth: 1) // Bordure subtile
        )
    }
}

/// 3. Sélecteur à glissière fluide
struct LiquidSegmentControl: View {
    @Binding var selectedIndex: Int
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<2) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                    }
                } label: {
                    ZStack {
                        if selectedIndex == index {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                        
                        Text(index == 0 ? "Connexion" : "Inscription")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedIndex == index ? .black : .secondary)
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(4)
        .background(Color.black.opacity(0.05))
        .cornerRadius(16)
    }
}

/// 4. Indicateur de force du mot de passe minimaliste
struct LiquidPasswordStrength: View {
    let strength: PasswordStrength
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<4) { index in
                Circle()
                    .fill(index < strength.score ? strength.color : Color.gray.opacity(0.2))
                    .frame(width: 6, height: 6)
            }
            Text(strength.rawValue)
                .font(.caption2)
                .foregroundStyle(strength.color)
        }
    }
}

// MARK: - Extensions Utiles
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
    }
}

// Extension pour utiliser les couleurs Hexadécimales facilement
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
#Preview {
    LiquidLoginView(authState: .constant(.authenticated))
}
