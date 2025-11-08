//
//  AddVehicleView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct AddVehicleView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var marque = ""
    @State private var modele = ""
    @State private var annee = Calendar.current.component(.year, from: Date())
    @State private var immatriculation = ""
    @State private var typeCarburant = "Essence"
    @State private var showAlert = false
    
    let fuelTypes = ["Essence", "Diesel", "Électrique", "Hybride", "GPL"]
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var isFormValid: Bool {
        !marque.isEmpty && !modele.isEmpty && !immatriculation.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informations du véhicule") {
                    TextField("Marque (ex: Toyota)", text: $marque)
                        .autocorrectionDisabled()
                    
                    TextField("Modèle (ex: Camry)", text: $modele)
                        .autocorrectionDisabled()
                    
                    TextField("Immatriculation", text: $immatriculation)
                        .textInputAutocapitalization(.characters)
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
                
                Section {
                    Button {
                        Task {
                            let request = CreateCarRequest(
                                marque: marque,
                                modele: modele,
                                annee: annee,
                                immatriculation: immatriculation,
                                typeCarburant: typeCarburant
                            )
                            
                            let success = await vehicleViewModel.createVehicle(request)
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
                            Text("Ajouter le véhicule")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isFormValid || vehicleViewModel.isLoading)
                }
            }
            .navigationTitle("Nouveau véhicule")
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
                Text(vehicleViewModel.errorMessage ?? "Impossible d'ajouter le véhicule")
            }
        }
    }
}

struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        AddVehicleView()
            .environmentObject(VehicleViewModel())
    }
}
