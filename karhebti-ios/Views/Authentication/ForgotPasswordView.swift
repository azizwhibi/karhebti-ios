//
//  ForgotPasswordView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.deepPurple, Color.deepPurple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Icon and title
                VStack(spacing: 16) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("Mot de passe oublié?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Entrez votre email et nous vous enverrons un lien pour réinitialiser votre mot de passe")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
                
                // Email field
                VStack(spacing: 16) {
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
                    
                    // Send button
                    Button {
                        Task {
                            await authViewModel.forgotPassword(email: email)
                            
                            if case .success = authViewModel.authState {
                                showSuccessAlert = true
                            } else if case .failure = authViewModel.authState {
                                showErrorAlert = true
                            }
                        }
                    } label: {
                        if case .loading = authViewModel.authState {
                            ProgressView()
                                .tint(.deepPurple)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        } else {
                            Text("Envoyer le lien")
                                .font(.headline)
                                .foregroundColor(.deepPurple)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .disabled(email.isEmpty)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Back to login
                Button("Retour à la connexion") {
                    dismiss()
                }
                .foregroundColor(.white)
                .fontWeight(.medium)
                
                Spacer()
                    .frame(height: 40)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Email envoyé", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Un lien de réinitialisation a été envoyé à votre adresse email")
        }
        .alert("Erreur", isPresented: $showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(authViewModel.errorMessage ?? "Une erreur est survenue")
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordView()
                .environmentObject(AuthViewModel())
        }
    }
}
