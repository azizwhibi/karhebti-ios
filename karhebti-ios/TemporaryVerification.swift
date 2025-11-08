//
//  TemporaryVerification.swift
//  karhebti-ios
//
//  This file is just to verify imports work
//  You can delete this file after verifying the project builds
//

import SwiftUI

// This file tests that all our custom types are accessible
struct TemporaryVerification {
    // Test Models
    let authResponse: AuthResponse? = nil
    let vehicle: CarResponse? = nil
    let maintenance: MaintenanceResponse? = nil
    let garage: GarageResponse? = nil
    let document: DocumentResponse? = nil
    
    // Test ViewModels
    let authVM = AuthViewModel()
    let vehicleVM = VehicleViewModel()
    let maintenanceVM = MaintenanceViewModel()
    let garageVM = GarageViewModel()
    let documentVM = DocumentViewModel()
    
    // Test Network
    let api = APIClient.shared
    let token = TokenManager.shared
    
    func test() {
        print("✅ All imports working!")
    }
}
