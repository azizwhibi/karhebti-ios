//
//  EditVehicleView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct EditVehicleView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @Environment(\.dismiss) var dismiss
    
    let vehicle: CarResponse
    
    @State private var marque: String
    @State private var modele: String
    @State private var annee: Int
    @State private var typeCarburant: String
    @State private var kilometrage: String
    @State private var statut: String
    @State private var showAlert = false
    
    let fuelTypes = ["Essence", "Diesel", "Électrique", "Hybride", "GPL"]
    let statusOptions = ["BON", "ATTENTION", "URGENT"]
    let currentYear = Calendar.current.component(.year, from: Date())
    
    init(vehicle: CarResponse) {
        self.vehicle = vehicle
        _marque = State(initialValue: vehicle.marque)
        _modele = State(initialValue: vehicle.modele)
        _annee = State(initialValue: vehicle.annee)
        _typeCarburant = State(initialValue: vehicle.typeCarburant)
        _kilometrage = State(initialValue: vehicle.kilometrage != nil ? String(vehicle.kilometrage!) : "")
        _statut = State(initialValue: vehicle.statut ?? "BON")
    }
    
    var isFormValid: Bool {
        !marque.isEmpty && !modele.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informations de base") {
                    TextField("Marque", text: $marque)
                        .autocorrectionDisabled()
                    
                    TextField("Modèle", text: $modele)
                        .autocorrectionDisabled()
                    
                    Picker("Année", selection: $annee) {
                        ForEach((1990...currentYear).reversed(), id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    
                    Picker("Type de carburant", selection: $typeCarburant) {
                        ForEach(fuelTypes, id: \.self) { fuel in
                            Text(fuel).tag(fuel)
                        }
                    }
                }
                
                Section("État du véhicule") {
                    TextField("Kilométrage", text: $kilometrage)
                        .keyboardType(.numberPad)
                    
                    Picker("Statut", selection: $statut) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                }
                
                Section {
                    Button {
                        Task {
                            let request = UpdateCarRequest(
                                marque: marque,
                                modele: modele,
                                annee: annee,
                                typeCarburant: typeCarburant,
                                kilometrage: Int(kilometrage),
                                statut: statut,
                                prochainEntretien: nil,
                                joursProchainEntretien: nil,
                                imageUrl: nil
                            )
                            
                            let success = await vehicleViewModel.updateVehicle(id: vehicle.id, request: request)
                            if success {
                                dismiss()
                            } else {
                                showAlert = true
                            }
                        }
                    } label: {
                        if vehicleViewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Enregistrer les modifications")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isFormValid || vehicleViewModel.isLoading)
                }
            }
            .navigationTitle("Modifier le véhicule")
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
                Text(vehicleViewModel.errorMessage ?? "Impossible de modifier le véhicule")
            }
        }
    }
}
