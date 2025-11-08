//
//  MaintenanceViewModel.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI
import Combine

@MainActor
class MaintenanceViewModel: ObservableObject {
    @Published var maintenances: [MaintenanceResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMaintenance: MaintenanceResponse?
    
    private let apiClient = APIClient.shared
    
    // MARK: - Fetch All Maintenances
    func fetchMaintenances() async {
        isLoading = true
        errorMessage = nil
        
        do {
            maintenances = try await apiClient.request(endpoint: "maintenances", method: .get)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Fetch Maintenances for Vehicle
    func fetchMaintenances(forVehicleId vehicleId: String) -> [MaintenanceResponse] {
        return maintenances.filter { $0.voiture == vehicleId }
    }
    
    // MARK: - Create Maintenance
    func createMaintenance(_ request: CreateMaintenanceRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let newMaintenance: MaintenanceResponse = try await apiClient.request(
                endpoint: "maintenances",
                method: .post,
                body: request
            )
            maintenances.append(newMaintenance)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Update Maintenance
    func updateMaintenance(id: String, request: UpdateMaintenanceRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedMaintenance: MaintenanceResponse = try await apiClient.request(
                endpoint: "maintenances/\(id)",
                method: .patch,
                body: request
            )
            if let index = maintenances.firstIndex(where: { $0.id == id }) {
                maintenances[index] = updatedMaintenance
            }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Delete Maintenance
    func deleteMaintenance(id: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let _: MessageResponse = try await apiClient.request(
                endpoint: "maintenances/\(id)",
                method: .delete
            )
            maintenances.removeAll { $0.id == id }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
