//
//  VehicleModels.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Car Request Models
struct CreateCarRequest: Codable {
    let marque: String          // Brand (e.g., "Toyota")
    let modele: String          // Model (e.g., "Camry")
    let annee: Int              // Year (e.g., 2020)
    let immatriculation: String // License plate
    let typeCarburant: String   // Fuel type: "Essence", "Diesel", "Électrique", "Hybride"
}

struct UpdateCarRequest: Codable {
    let marque: String?
    let modele: String?
    let annee: Int?
    let typeCarburant: String?
    let kilometrage: Int?            // Mileage in km
    let statut: String?              // Status: "BON", "ATTENTION", "URGENT"
    let prochainEntretien: String?   // Next maintenance date (ISO 8601)
    let joursProchainEntretien: Int? // Days until next maintenance
    let imageUrl: String?            // Vehicle image URL
}

// MARK: - Car Response Model
struct CarResponse: Codable, Identifiable {
    let id: String
    let marque: String
    let modele: String
    let annee: Int
    let immatriculation: String
    let typeCarburant: String
    let kilometrage: Int?
    let statut: String?
    let prochainEntretien: String?
    let joursProchainEntretien: Int?
    let imageUrl: String?
    let user: UserResponse?    // Full user object
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case marque, modele, annee, immatriculation, typeCarburant
        case kilometrage, statut, prochainEntretien, joursProchainEntretien
        case imageUrl, user, createdAt, updatedAt
    }
}

// MARK: - Vehicle Status Enum
enum VehicleStatus: String, Codable, CaseIterable {
    case bon = "BON"              // Good condition
    case attention = "ATTENTION"   // Needs attention
    case urgent = "URGENT"         // Urgent maintenance needed
    
    var displayName: String {
        switch self {
        case .bon: return "Bon état"
        case .attention: return "Attention"
        case .urgent: return "Urgent"
        }
    }
    
    var color: Color {
        switch self {
        case .bon: return .green
        case .attention: return .yellow
        case .urgent: return .red
        }
    }
}

// MARK: - Fuel Type Enum
enum FuelType: String, Codable, CaseIterable {
    case essence = "Essence"
    case diesel = "Diesel"
    case electrique = "Électrique"
    case hybride = "Hybride"
    case gpl = "GPL"
}
