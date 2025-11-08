//
//  AddMaintenanceView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct AddMaintenanceView: View {
    @EnvironmentObject var maintenanceViewModel: MaintenanceViewModel
    @Environment(\.dismiss) var dismiss
    
    let vehicleId: String
    
    @State private var type = "vidange"
    @State private var date = Date()
    @State private var cout = ""
    @State private var garageId = ""
    @State private var showAlert = false
    
    let maintenanceTypes = [
        "vidange", "révision", "pneus", "freins", "filtre",
        "contrôle technique", "batterie", "climatisation", "réparation", "autre"
    ]
    
    var isFormValid: Bool {
        !type.isEmpty && !cout.isEmpty && Double(cout) != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Type d'entretien") {
                    Picker("Type", selection: $type) {
                        ForEach(maintenanceTypes, id: \.self) { maintenanceType in
                            Text(maintenanceType.capitalized).tag(maintenanceType)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Coût") {
                    HStack {
                        TextField("Montant", text: $cout)
                            .keyboardType(.decimalPad)
                        
                        Text("€")
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Section("Garage (optionnel)") {
                    TextField("ID du garage", text: $garageId)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section {
                    Button {
                        Task {
                            guard let coutValue = Double(cout) else { return }
                            
                            let dateFormatter = ISO8601DateFormatter()
                            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            let dateString = dateFormatter.string(from: date)
                            
                            let request = CreateMaintenanceRequest(
                                type: type,
                                date: dateString,
                                cout: coutValue,
                                garage: garageId.isEmpty ? "" : garageId,
                                voiture: vehicleId
                            )
                            
                            let success = await maintenanceViewModel.createMaintenance(request)
                            if success {
                                dismiss()
                            } else {
                                showAlert = true
                            }
                        }
                    } label: {
                        if maintenanceViewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Enregistrer l'entretien")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isFormValid || maintenanceViewModel.isLoading)
                }
            }
            .navigationTitle("Nouvel entretien")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
            .alert("Erreur", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(maintenanceViewModel.errorMessage ?? "Impossible d'enregistrer l'entretien")
            }
        }
    }
}
