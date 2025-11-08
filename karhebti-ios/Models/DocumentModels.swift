//
//  DocumentModels.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import Foundation

// MARK: - Document Request Models
struct CreateDocumentRequest: Codable {
    let type: String              // "assurance", "carte grise", "contrôle technique"
    let dateEmission: String      // Issue date
    let dateExpiration: String    // Expiry date
    let fichier: String           // File URL or path
    let voiture: String           // Car ID
}

struct UpdateDocumentRequest: Codable {
    let type: String?
    let dateEmission: String?
    let dateExpiration: String?
}

// MARK: - Document Response Model
struct DocumentResponse: Codable, Identifiable {
    let id: String
    let type: String
    let dateEmission: Date
    let dateExpiration: Date
    let fichier: String
    let voiture: String  // Car ID
    let user: String?    // User ID
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, dateEmission, dateExpiration, fichier, voiture, user
        case createdAt, updatedAt
    }
}

// MARK: - Document Type Enum
enum DocumentType: String, Codable, CaseIterable {
    case assurance = "assurance"                   // Insurance
    case carteGrise = "carte grise"                // Registration
    case controleTechnique = "contrôle technique"  // Technical inspection
    case permis = "permis"                         // License
    case facture = "facture"                       // Invoice
    case autre = "autre"                           // Other
    
    var icon: String {
        switch self {
        case .assurance: return "shield.fill"
        case .carteGrise: return "doc.text.fill"
        case .controleTechnique: return "checkmark.seal.fill"
        case .permis: return "person.text.rectangle.fill"
        case .facture: return "dollarsign.circle.fill"
        case .autre: return "doc.fill"
        }
    }
}
