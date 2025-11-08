//
//  MaintenanceModels.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import Foundation

// MARK: - Maintenance Request Models
struct CreateMaintenanceRequest: Codable {
    let type: String      // "vidange", "révision", "réparation", etc.
    let date: String      // ISO 8601 date format
    let cout: Double      // Cost in local currency
    let garage: String    // Garage ID
    let voiture: String   // Car ID
}

struct UpdateMaintenanceRequest: Codable {
    let type: String?
    let date: String?
    let cout: Double?
}

// MARK: - Maintenance Response Model
struct MaintenanceResponse: Codable, Identifiable {
    let id: String
    let type: String
    let date: Date
    let cout: Double
    let garage: String?  // Garage ID
    let voiture: String? // Car ID
    let user: String?    // User ID
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, date, cout, garage, voiture, user, createdAt, updatedAt
    }
}

// MARK: - Maintenance Type Enum
enum MaintenanceType: String, Codable, CaseIterable {
    case vidange = "vidange"                     // Oil change
    case revision = "révision"                   // General revision
    case pneus = "pneus"                         // Tires
    case freins = "freins"                       // Brakes
    case filtre = "filtre"                       // Filter
    case controleTechnique = "contrôle technique" // Technical inspection
    case batterie = "batterie"                   // Battery
    case climatisation = "climatisation"         // AC
    case reparation = "réparation"               // Repair
    case autre = "autre"                         // Other
    
    var icon: String {
        switch self {
        case .vidange: return "drop.fill"
        case .revision: return "wrench.fill"
        case .pneus: return "circle.fill"
        case .freins: return "brake.signal"
        case .filtre: return "wind"
        case .controleTechnique: return "checkmark.seal.fill"
        case .batterie: return "battery.100"
        case .climatisation: return "snowflake"
        case .reparation: return "hammer.fill"
        case .autre: return "ellipsis.circle.fill"
        }
    }
}
