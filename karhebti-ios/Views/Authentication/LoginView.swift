//
//  LoginView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showPassword = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.deepPurple, Color.deepPurple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                            .frame(height: 60)
                        
                        // Logo and title
                        VStack(spacing: 12) {
                            Image(systemName: "car.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            Text("Karhebti")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Gérez vos véhicules facilement")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.bottom, 40)
                        
                        // Login form
                        VStack(spacing: 16) {
                            // Email field
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                TextField("Email", text: $email)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            // Password field
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                
                                if showPassword {
                                    TextField("Mot de passe", text: $password)
                                } else {
                                    SecureField("Mot de passe", text: $password)
                                }
                                
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            // Remember Me
                            Toggle("Se souvenir de moi", isOn: $rememberMe)
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                            
                            // Login button
                            Button {
                                Task {
                                    await authViewModel.login(email: email, password: password, rememberMe: rememberMe)
                                }
                            } label: {
                                if case .loading = authViewModel.authState {
                                    ProgressView()
                                        .tint(.deepPurple)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                } else {
                                    Text("Se connecter")
                                        .font(.headline)
                                        .foregroundColor(.deepPurple)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .disabled(email.isEmpty || password.isEmpty)
                            
                            // Forgot password
                            NavigationLink("Mot de passe oublié?") {
                                ForgotPasswordView()
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        // Sign up link
                        HStack {
                            Text("Pas encore de compte?")
                                .foregroundColor(.white)
                            NavigationLink("S'inscrire") {
                                SignUpView()
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .onAppear {
                // Load remembered email
                if let savedEmail = authViewModel.getRememberedEmail() {
                    email = savedEmail
                    rememberMe = true
                }
            }
            .alert("Erreur", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(authViewModel.errorMessage ?? "Une erreur est survenue")
            }
            .onChange(of: authViewModel.authState) { newState in
                if case .failure = newState {
                    showAlert = true
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
