//
//  VehiclesListView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct VehiclesListView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @EnvironmentObject var maintenanceViewModel: MaintenanceViewModel
    @EnvironmentObject var documentViewModel: DocumentViewModel
    @State private var showAddVehicle = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if vehicleViewModel.isLoading && vehicleViewModel.vehicles.isEmpty {
                    LoadingView()
                } else if let errorMessage = vehicleViewModel.errorMessage {
                    ErrorView(
                        message: errorMessage,
                        retryAction: {
                            Task {
                                await vehicleViewModel.fetchVehicles()
                            }
                        }
                    )
                } else if vehicleViewModel.vehicles.isEmpty {
                    EmptyStateView(
                        icon: "car.fill",
                        title: "Aucun véhicule",
                        message: "Ajoutez votre premier véhicule pour commencer",
                        actionTitle: "Ajouter un véhicule",
                        action: { showAddVehicle = true }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(vehicleViewModel.vehicles) { vehicle in
                                NavigationLink(destination: VehicleDetailView(vehicle: vehicle)
                                    .environmentObject(vehicleViewModel)
                                    .environmentObject(maintenanceViewModel)
                                    .environmentObject(documentViewModel)
                                ) {
                                    VehicleCardView(vehicle: vehicle)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await vehicleViewModel.fetchVehicles()
                    }
                }
            }
            .background(Color.softWhite)
            .navigationTitle("Mes Véhicules")
            .onAppear {
                Task {
                    await vehicleViewModel.fetchVehicles()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddVehicle = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.deepPurple)
                    }
                }
            }
            .sheet(isPresented: $showAddVehicle) {
                AddVehicleView()
                    .environmentObject(vehicleViewModel)
            }
        }
    }
}

// MARK: - Vehicle Card View
struct VehicleCardView: View {
    let vehicle: CarResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(vehicle.marque) \(vehicle.modele)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(vehicle.immatriculation)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                if let status = vehicle.statut {
                    StatusBadge(status: status)
                }
            }
            
            // Details
            HStack(spacing: 20) {
                DetailItem(icon: "calendar", text: String(vehicle.annee))
                DetailItem(icon: "fuelpump.fill", text: vehicle.typeCarburant)
                
                if let km = vehicle.kilometrage {
                    DetailItem(icon: "speedometer", text: "\(km) km")
                }
            }
            
            // Next maintenance
            if let nextMaintenance = vehicle.prochainEntretien,
               let days = vehicle.joursProchainEntretien {
                Divider()
                
                HStack {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .foregroundColor(.accentBlue)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Prochain entretien")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("Dans \(days) jours")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Detail Item Component
struct DetailItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: String
    
    var statusColor: Color {
        switch status {
        case "BON": return .statusGood
        case "ATTENTION": return .statusAttention
        case "URGENT": return .statusUrgent
        default: return .mediumGrey
        }
    }
    
    var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(statusColor.opacity(0.15))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
}

struct VehiclesListView_Previews: PreviewProvider {
    static var previews: some View {
        VehiclesListView()
            .environmentObject(VehicleViewModel())
            .environmentObject(MaintenanceViewModel())
            .environmentObject(DocumentViewModel())
    }
}
