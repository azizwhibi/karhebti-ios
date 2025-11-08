//
//  AuthModels.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import Foundation

// MARK: - Auth Request Models
struct SignupRequest: Codable {
    let nom: String           // Last name
    let prenom: String        // First name
    let email: String
    let motDePasse: String    // Password
    let telephone: String
}

struct LoginRequest: Codable {
    let email: String
    let motDePasse: String
}

struct ForgotPasswordRequest: Codable {
    let email: String
}

struct ResetPasswordRequest: Codable {
    let token: String
    let nouveauMotDePasse: String  // New password
}

// MARK: - Auth Response Models
struct AuthResponse: Codable {
    let accessToken: String
    let user: UserResponse
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}

struct MessageResponse: Codable {
    let message: String
}

// MARK: - User Response Model
struct UserResponse: Codable {
    let id: String?
    let nom: String
    let prenom: String
    let email: String
    let telephone: String?
    let role: String        // "user" or "admin"
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nom, prenom, email, telephone, role, createdAt, updatedAt
    }
}

struct UpdateUserRequest: Codable {
    let nom: String?
    let prenom: String?
    let telephone: String?
}

struct UpdateRoleRequest: Codable {
    let role: String
}
