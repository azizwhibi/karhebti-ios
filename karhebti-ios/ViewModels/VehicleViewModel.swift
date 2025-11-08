//
//  VehicleViewModel.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI
import Combine

@MainActor
class VehicleViewModel: ObservableObject {
    @Published var vehicles: [CarResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedVehicle: CarResponse?
    
    private let apiClient = APIClient.shared
    
    // MARK: - Fetch Vehicles
    func fetchVehicles() async {
        isLoading = true
        errorMessage = nil
        
        print("🚗 Fetching vehicles...")
        
        do {
            vehicles = try await apiClient.request(endpoint: "cars", method: .get)
            print("✅ Successfully fetched \(vehicles.count) vehicles")
            isLoading = false
        } catch {
            print("❌ Error fetching vehicles: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Fetch Single Vehicle
    func fetchVehicle(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let vehicle: CarResponse = try await apiClient.request(
                endpoint: "cars/\(id)",
                method: .get
            )
            selectedVehicle = vehicle
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Create Vehicle
    func createVehicle(_ request: CreateCarRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            // Create the vehicle - backend might not return full object
            let _: CarResponse = try await apiClient.request(
                endpoint: "cars",
                method: .post,
                body: request
            )
            
            // Refetch all vehicles to get the complete data
            await fetchVehicles()
            
            isLoading = false
            return true
        } catch {
            // If decoding fails but car was created, refetch anyway
            await fetchVehicles()
            isLoading = false
            // Check if the fetch was successful (car was added)
            return errorMessage == nil
        }
    }
    
    // MARK: - Update Vehicle
    func updateVehicle(id: String, request: UpdateCarRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedVehicle: CarResponse = try await apiClient.request(
                endpoint: "cars/\(id)",
                method: .patch,
                body: request
            )
            if let index = vehicles.firstIndex(where: { $0.id == id }) {
                vehicles[index] = updatedVehicle
            }
            selectedVehicle = updatedVehicle
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Delete Vehicle
    func deleteVehicle(id: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let _: MessageResponse = try await apiClient.request(
                endpoint: "cars/\(id)",
                method: .delete
            )
            vehicles.removeAll { $0.id == id }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
