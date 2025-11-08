//
//  SignUpView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nom = ""
    @State private var prenom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var isFormValid: Bool {
        !nom.isEmpty && !prenom.isEmpty && !email.isEmpty &&
        !telephone.isEmpty && !password.isEmpty &&
        password == confirmPassword && password.count >= 6
    }
    
    var body: some View {
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
                    // Title
                    VStack(spacing: 8) {
                        Text("Créer un compte")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Rejoignez Karhebti aujourd'hui")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Sign up form
                    VStack(spacing: 16) {
                        // Nom field
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Nom", text: $nom)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Prenom field
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Prénom", text: $prenom)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
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
                        
                        // Telephone field
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.gray)
                            TextField("Téléphone", text: $telephone)
                                .keyboardType(.phonePad)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Password field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            
                            if showPassword {
                                TextField("Mot de passe (min. 6 caractères)", text: $password)
                            } else {
                                SecureField("Mot de passe (min. 6 caractères)", text: $password)
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
                        
                        // Confirm Password field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            
                            if showConfirmPassword {
                                TextField("Confirmer le mot de passe", text: $confirmPassword)
                            } else {
                                SecureField("Confirmer le mot de passe", text: $confirmPassword)
                            }
                            
                            Button {
                                showConfirmPassword.toggle()
                            } label: {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Password match indicator
                        if !confirmPassword.isEmpty {
                            HStack {
                                Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(password == confirmPassword ? .green : .red)
                                Text(password == confirmPassword ? "Les mots de passe correspondent" : "Les mots de passe ne correspondent pas")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Sign up button
                        Button {
                            Task {
                                await authViewModel.signup(
                                    nom: nom,
                                    prenom: prenom,
                                    email: email,
                                    password: password,
                                    telephone: telephone
                                )
                                
                                if case .success = authViewModel.authState {
                                    dismiss()
                                }
                            }
                        } label: {
                            if case .loading = authViewModel.authState {
                                ProgressView()
                                    .tint(.deepPurple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            } else {
                                Text("S'inscrire")
                                    .font(.headline)
                                    .foregroundColor(.deepPurple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Login link
                    HStack {
                        Text("Vous avez déjà un compte?")
                            .foregroundColor(.white)
                        Button("Se connecter") {
                            dismiss()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
                .environmentObject(AuthViewModel())
        }
    }
}
