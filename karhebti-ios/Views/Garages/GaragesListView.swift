//
//  GaragesListView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct GaragesListView: View {
    @EnvironmentObject var garageViewModel: GarageViewModel
    @State private var searchText = ""
    @State private var showAddGarage = false
    
    var filteredGarages: [GarageResponse] {
        if searchText.isEmpty {
            return garageViewModel.garages
        } else {
            return garageViewModel.garages.filter { garage in
                garage.nom.localizedCaseInsensitiveContains(searchText) ||
                garage.adresse.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if garageViewModel.isLoading && garageViewModel.garages.isEmpty {
                    LoadingView()
                } else if garageViewModel.garages.isEmpty {
                    EmptyStateView(
                        icon: "wrench.and.screwdriver.fill",
                        title: "Aucun garage",
                        message: "Ajoutez des garages pour faciliter vos entretiens"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredGarages) { garage in
                                NavigationLink(destination: GarageDetailView(garage: garage)
                                    .environmentObject(garageViewModel)
                                ) {
                                    GarageCardView(garage: garage)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    .searchable(text: $searchText, prompt: "Rechercher un garage")
                    .refreshable {
                        await garageViewModel.fetchGarages()
                    }
                }
            }
            .background(Color.softWhite)
            .navigationTitle("Garages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddGarage = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.deepPurple)
                    }
                }
            }
            .sheet(isPresented: $showAddGarage) {
                AddGarageView()
                    .environmentObject(garageViewModel)
            }
        }
    }
}

// MARK: - Garage Card View
struct GarageCardView: View {
    let garage: GarageResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(garage.nom)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(garage.adresse)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            // Rating
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(garage.noteUtilisateur) ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(.accentYellow)
                }
                
                Text(String(format: "%.1f", garage.noteUtilisateur))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            // Services
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(garage.typeService.prefix(4), id: \.self) { service in
                        Text(service)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.deepPurple.opacity(0.1))
                            .foregroundColor(.deepPurple)
                            .cornerRadius(6)
                    }
                    
                    if garage.typeService.count > 4 {
                        Text("+\(garage.typeService.count - 4)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.lightGrey)
                            .foregroundColor(.textSecondary)
                            .cornerRadius(6)
                    }
                }
            }
            
            // Contact
            HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .font(.caption)
                    .foregroundColor(.accentBlue)
                
                Text(garage.telephone)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

struct GaragesListView_Previews: PreviewProvider {
    static var previews: some View {
        GaragesListView()
            .environmentObject(GarageViewModel())
    }
}
