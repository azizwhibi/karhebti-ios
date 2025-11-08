//
//  GarageViewModel.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI
import Combine

@MainActor
class GarageViewModel: ObservableObject {
    @Published var garages: [GarageResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedGarage: GarageResponse?
    
    private let apiClient = APIClient.shared
    
    // MARK: - Fetch All Garages
    func fetchGarages() async {
        isLoading = true
        errorMessage = nil
        
        do {
            garages = try await apiClient.request(endpoint: "garages", method: .get)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Fetch Single Garage
    func fetchGarage(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let garage: GarageResponse = try await apiClient.request(
                endpoint: "garages/\(id)",
                method: .get
            )
            selectedGarage = garage
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Create Garage
    func createGarage(_ request: CreateGarageRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let newGarage: GarageResponse = try await apiClient.request(
                endpoint: "garages",
                method: .post,
                body: request
            )
            garages.append(newGarage)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Update Garage
    func updateGarage(id: String, request: UpdateGarageRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedGarage: GarageResponse = try await apiClient.request(
                endpoint: "garages/\(id)",
                method: .patch,
                body: request
            )
            if let index = garages.firstIndex(where: { $0.id == id }) {
                garages[index] = updatedGarage
            }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Delete Garage
    func deleteGarage(id: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let _: MessageResponse = try await apiClient.request(
                endpoint: "garages/\(id)",
                method: .delete
            )
            garages.removeAll { $0.id == id }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
