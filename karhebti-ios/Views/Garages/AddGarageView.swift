//
//  AddGarageView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct AddGarageView: View {
    @EnvironmentObject var garageViewModel: GarageViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nom = ""
    @State private var adresse = ""
    @State private var telephone = ""
    @State private var selectedServices: Set<String> = []
    @State private var showAlert = false
    
    let availableServices = [
        "vidange", "révision", "pneus", "freins",
        "contrôle technique", "batterie", "climatisation", "carrosserie"
    ]
    
    var isFormValid: Bool {
        !nom.isEmpty && !adresse.isEmpty && !telephone.isEmpty && !selectedServices.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informations du garage") {
                    TextField("Nom du garage", text: $nom)
                        .autocorrectionDisabled()
                    
                    TextField("Adresse complète", text: $adresse)
                        .autocorrectionDisabled()
                    
                    TextField("Téléphone", text: $telephone)
                        .keyboardType(.phonePad)
                }
                
                Section("Services proposés") {
                    ForEach(availableServices, id: \.self) { service in
                        Button {
                            if selectedServices.contains(service) {
                                selectedServices.remove(service)
                            } else {
                                selectedServices.insert(service)
                            }
                        } label: {
                            HStack {
                                Text(service.capitalized)
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                if selectedServices.contains(service) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.deepPurple)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.mediumGrey)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        Task {
                            let request = CreateGarageRequest(
                                nom: nom,
                                adresse: adresse,
                                typeService: Array(selectedServices),
                                telephone: telephone,
                                noteUtilisateur: 0
                            )
                            
                            let success = await garageViewModel.createGarage(request)
                            if success {
                                dismiss()
                            } else {
                                showAlert = true
                            }
                        }
                    } label: {
                        if garageViewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Ajouter le garage")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isFormValid || garageViewModel.isLoading)
                }
            }
            .navigationTitle("Nouveau garage")
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
                Text(garageViewModel.errorMessage ?? "Impossible d'ajouter le garage")
            }
        }
    }
}

struct AddGarageView_Previews: PreviewProvider {
    static var previews: some View {
        AddGarageView()
            .environmentObject(GarageViewModel())
    }
}
