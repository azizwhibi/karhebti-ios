//
//  AuthViewModel.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .idle
    @Published var currentUser: UserData?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient.shared
    private let tokenManager = TokenManager.shared
    
    enum AuthState: Equatable {
        case idle
        case loading
        case success
        case failure(String)
    }
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isAuthenticated = tokenManager.isLoggedIn()
        currentUser = tokenManager.getUser()
    }
    
    // MARK: - Login
    func login(email: String, password: String, rememberMe: Bool) async {
        authState = .loading
        errorMessage = nil
        
        do {
            let request = LoginRequest(email: email, motDePasse: password)
            let response: AuthResponse = try await apiClient.request(
                endpoint: "auth/login",
                method: .post,
                body: request,
                requiresAuth: false
            )
            
            // Save token and user
            tokenManager.saveToken(response.accessToken)
            let userData = UserData(
                id: response.user.id,
                email: response.user.email,
                nom: response.user.nom,
                prenom: response.user.prenom,
                role: response.user.role,
                telephone: response.user.telephone
            )
            tokenManager.saveUser(userData)
            
            // Handle Remember Me
            if rememberMe {
                saveRememberMe(email: email)
            } else {
                clearRememberMe()
            }
            
            currentUser = userData
            isAuthenticated = true
            authState = .success
        } catch {
            authState = .failure(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Signup
    func signup(nom: String, prenom: String, email: String, password: String, telephone: String) async {
        authState = .loading
        errorMessage = nil
        
        do {
            let request = SignupRequest(
                nom: nom,
                prenom: prenom,
                email: email,
                motDePasse: password,
                telephone: telephone
            )
            let response: AuthResponse = try await apiClient.request(
                endpoint: "auth/signup",
                method: .post,
                body: request,
                requiresAuth: false
            )
            
            tokenManager.saveToken(response.accessToken)
            let userData = UserData(
                id: response.user.id,
                email: response.user.email,
                nom: response.user.nom,
                prenom: response.user.prenom,
                role: response.user.role,
                telephone: response.user.telephone
            )
            tokenManager.saveUser(userData)
            
            currentUser = userData
            isAuthenticated = true
            authState = .success
        } catch {
            authState = .failure(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Forgot Password
    func forgotPassword(email: String) async {
        authState = .loading
        errorMessage = nil
        
        do {
            let request = ForgotPasswordRequest(email: email)
            let _: MessageResponse = try await apiClient.request(
                endpoint: "auth/forgot-password",
                method: .post,
                body: request,
                requiresAuth: false
            )
            authState = .success
        } catch {
            authState = .failure(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Logout
    func logout() {
        tokenManager.clearAll()
        clearRememberMe()
        currentUser = nil
        isAuthenticated = false
        authState = .idle
    }
    
    // MARK: - Remember Me Helpers
    private func saveRememberMe(email: String) {
        UserDefaults.standard.set(email, forKey: "rememberMe_email")
        UserDefaults.standard.set(true, forKey: "rememberMe_enabled")
    }
    
    private func clearRememberMe() {
        UserDefaults.standard.removeObject(forKey: "rememberMe_email")
        UserDefaults.standard.set(false, forKey: "rememberMe_enabled")
    }
    
    func getRememberedEmail() -> String? {
        guard UserDefaults.standard.bool(forKey: "rememberMe_enabled") else {
            return nil
        }
        return UserDefaults.standard.string(forKey: "rememberMe_email")
    }
}
