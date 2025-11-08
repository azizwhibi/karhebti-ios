//
//  GarageModels.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import Foundation

// MARK: - Garage Request Models
struct CreateGarageRequest: Codable {
    let nom: String
    let adresse: String
    let typeService: [String]  // Array of service types
    let telephone: String
    let noteUtilisateur: Double?  // User rating (0-5)
}

struct UpdateGarageRequest: Codable {
    let nom: String?
    let adresse: String?
    let typeService: [String]?
    let telephone: String?
    let noteUtilisateur: Double?
}

// MARK: - Garage Response Model
struct GarageResponse: Codable, Identifiable {
    let id: String
    let nom: String
    let adresse: String
    let typeService: [String]
    let telephone: String
    let noteUtilisateur: Double
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nom, adresse, typeService, telephone, noteUtilisateur
        case createdAt, updatedAt
    }
}

// MARK: - Garage Service Enum
enum GarageService: String, Codable, CaseIterable {
    case revision = "révision"
    case vidange = "vidange"
    case pneus = "pneus"
    case freins = "freins"
    case controleTechnique = "contrôle technique"
    case batterie = "batterie"
    case climatisation = "climatisation"
    case carrosserie = "carrosserie"
    
    var displayName: String { rawValue.capitalized }
}
