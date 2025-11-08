//
//  VehicleDetailView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct VehicleDetailView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @EnvironmentObject var maintenanceViewModel: MaintenanceViewModel
    @EnvironmentObject var documentViewModel: DocumentViewModel
    @Environment(\.dismiss) var dismiss
    
    let vehicle: CarResponse
    
    @State private var showEditView = false
    @State private var showDeleteAlert = false
    @State private var showAddMaintenance = false
    
    var vehicleMaintenances: [MaintenanceResponse] {
        maintenanceViewModel.fetchMaintenances(forVehicleId: vehicle.id)
    }
    
    var vehicleDocuments: [DocumentResponse] {
        documentViewModel.fetchDocuments(forVehicleId: vehicle.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Vehicle Header Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(vehicle.marque) \(vehicle.modele)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                            
                            Text(vehicle.immatriculation)
                                .font(.title3)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        if let status = vehicle.statut {
                            VStack {
                                StatusBadge(status: status)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Vehicle Details Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        DetailRow(icon: "calendar", label: "Année", value: String(vehicle.annee))
                        DetailRow(icon: "fuelpump.fill", label: "Carburant", value: vehicle.typeCarburant)
                        
                        if let km = vehicle.kilometrage {
                            DetailRow(icon: "speedometer", label: "Kilométrage", value: "\(km) km")
                        }
                        
                        if let days = vehicle.joursProchainEntretien {
                            DetailRow(icon: "wrench.fill", label: "Prochain entretien", value: "Dans \(days) jours")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Maintenance Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Entretiens")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button {
                            showAddMaintenance = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                Text("Ajouter")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.deepPurple)
                        }
                    }
                    
                    if vehicleMaintenances.isEmpty {
                        Text("Aucun entretien enregistré")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(vehicleMaintenances.sorted(by: { $0.date > $1.date })) { maintenance in
                            MaintenanceCardCompact(maintenance: maintenance)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Documents Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Documents")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button {
                            // Add document action
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                Text("Ajouter")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.deepPurple)
                        }
                    }
                    
                    if vehicleDocuments.isEmpty {
                        Text("Aucun document")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(vehicleDocuments) { document in
                            DocumentCardCompact(document: document)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Text("Supprimer le véhicule")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.alertRed)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(Color.softWhite)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEditView) {
            EditVehicleView(vehicle: vehicle)
                .environmentObject(vehicleViewModel)
        }
        .sheet(isPresented: $showAddMaintenance) {
            AddMaintenanceView(vehicleId: vehicle.id)
                .environmentObject(maintenanceViewModel)
        }
        .alert("Supprimer le véhicule", isPresented: $showDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task { @MainActor in
                    let success = await vehicleViewModel.deleteVehicle(id: vehicle.id)
                    if success {
                        // Refresh the vehicles list
                        await vehicleViewModel.fetchVehicles()
                    }
                    // Always dismiss after delete attempt
                    dismiss()
                }
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer ce véhicule? Cette action est irréversible.")
        }
    }
}

// MARK: - Detail Row Component
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.deepPurple)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Maintenance Card Compact
struct MaintenanceCardCompact: View {
    let maintenance: MaintenanceResponse
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: MaintenanceType(rawValue: maintenance.type)?.icon ?? "wrench.fill")
                .font(.title2)
                .foregroundColor(.accentBlue)
                .frame(width: 40, height: 40)
                .background(Color.accentBlue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(maintenance.type.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                
                Text(maintenance.date.formatted("dd/MM/yyyy"))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text("\(Int(maintenance.cout))€")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
        }
        .padding()
        .background(Color.softWhite)
        .cornerRadius(12)
    }
}

// MARK: - Document Card Compact
struct DocumentCardCompact: View {
    let document: DocumentResponse
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: DocumentType(rawValue: document.type)?.icon ?? "doc.fill")
                .font(.title2)
                .foregroundColor(.accentGreen)
                .frame(width: 40, height: 40)
                .background(Color.accentGreen.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(document.type.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                
                Text("Expire: \(document.dateExpiration.formatted("dd/MM/yyyy"))")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.mediumGrey)
        }
        .padding()
        .background(Color.softWhite)
        .cornerRadius(12)
    }
}

struct VehicleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VehicleDetailView(vehicle: CarResponse(
                id: "1",
                marque: "Toyota",
                modele: "Camry",
                annee: 2020,
                immatriculation: "ABC-123",
                typeCarburant: "Essence",
                kilometrage: 50000,
                statut: "BON",
                prochainEntretien: nil,
                joursProchainEntretien: 30,
                imageUrl: nil,
                user: nil,
                createdAt: Date(),
                updatedAt: Date()
            ))
            .environmentObject(VehicleViewModel())
            .environmentObject(MaintenanceViewModel())
            .environmentObject(DocumentViewModel())
        }
    }
}
