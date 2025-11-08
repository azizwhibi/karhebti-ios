//
//  HomeView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var vehicleViewModel = VehicleViewModel()
    @StateObject private var maintenanceViewModel = MaintenanceViewModel()
    @StateObject private var garageViewModel = GarageViewModel()
    @StateObject private var documentViewModel = DocumentViewModel()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Tab
            DashboardView()
                .environmentObject(vehicleViewModel)
                .environmentObject(maintenanceViewModel)
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
                .tag(0)
            
            // Vehicles Tab
            VehiclesListView()
                .environmentObject(vehicleViewModel)
                .environmentObject(maintenanceViewModel)
                .environmentObject(documentViewModel)
                .tabItem {
                    Label("Véhicules", systemImage: "car.fill")
                }
                .tag(1)
            
            // Garages Tab
            GaragesListView()
                .environmentObject(garageViewModel)
                .tabItem {
                    Label("Garages", systemImage: "wrench.and.screwdriver.fill")
                }
                .tag(2)
            
            // Profile Tab
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.deepPurple)
        .onAppear {
            Task {
                await vehicleViewModel.fetchVehicles()
                await maintenanceViewModel.fetchMaintenances()
                await garageViewModel.fetchGarages()
                await documentViewModel.fetchDocuments()
            }
        }
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @EnvironmentObject var maintenanceViewModel: MaintenanceViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bonjour, \(authViewModel.currentUser?.prenom ?? "")!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        
                        Text("Gérez vos véhicules et maintenances")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.deepPurple.opacity(0.1), Color.lightPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Statistics Cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Véhicules",
                            value: "\(vehicleViewModel.vehicles.count)",
                            icon: "car.fill",
                            color: .deepPurple
                        )
                        
                        StatCard(
                            title: "Entretiens",
                            value: "\(maintenanceViewModel.maintenances.count)",
                            icon: "wrench.fill",
                            color: .accentBlue
                        )
                    }
                    .padding(.horizontal)
                    
                    // Recent Vehicles
                    if !vehicleViewModel.vehicles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Vos véhicules")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ForEach(vehicleViewModel.vehicles.prefix(3)) { vehicle in
                                NavigationLink(destination: VehicleDetailView(vehicle: vehicle)
                                    .environmentObject(vehicleViewModel)
                                    .environmentObject(maintenanceViewModel)
                                    .environmentObject(DocumentViewModel())
                                ) {
                                    VehicleCardCompact(vehicle: vehicle)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        EmptyStateView(
                            icon: "car.fill",
                            title: "Aucun véhicule",
                            message: "Ajoutez votre premier véhicule pour commencer"
                        )
                        .padding()
                    }
                    
                    Spacer()
                        .frame(height: 20)
                }
                .padding(.vertical)
            }
            .background(Color.softWhite)
            .navigationTitle("Karhebti")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Compact Vehicle Card
struct VehicleCardCompact: View {
    let vehicle: CarResponse
    
    var body: some View {
        HStack(spacing: 12) {
            // Vehicle icon
            Image(systemName: "car.fill")
                .font(.system(size: 40))
                .foregroundColor(.deepPurple)
                .frame(width: 60, height: 60)
                .background(Color.lightPurple)
                .cornerRadius(12)
            
            // Vehicle info
            VStack(alignment: .leading, spacing: 4) {
                Text("\(vehicle.marque) \(vehicle.modele)")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(vehicle.immatriculation)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                
                HStack(spacing: 8) {
                    Text(vehicle.typeCarburant)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if let status = vehicle.statut {
                        StatusBadge(status: status)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.mediumGrey)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                // User Info Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.deepPurple)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(authViewModel.currentUser?.prenom ?? "") \(authViewModel.currentUser?.nom ?? "")")
                                .font(.headline)
                            
                            Text(authViewModel.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                            
                            if let telephone = authViewModel.currentUser?.telephone {
                                Text(telephone)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Settings Section
                Section("Paramètres") {
                    NavigationLink {
                        Text("Préférences")
                    } label: {
                        Label("Préférences", systemImage: "gear")
                    }
                    
                    NavigationLink {
                        Text("Notifications")
                    } label: {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    NavigationLink {
                        Text("Confidentialité")
                    } label: {
                        Label("Confidentialité", systemImage: "lock.fill")
                    }
                }
                
                // About Section
                Section("À propos") {
                    NavigationLink {
                        Text("Aide et support")
                    } label: {
                        Label("Aide et support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink {
                        Text("Conditions d'utilisation")
                    } label: {
                        Label("Conditions", systemImage: "doc.text")
                    }
                }
                
                // Logout Section
                Section {
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.alertRed)
                        }
                    }
                }
            }
            .navigationTitle("Profil")
            .alert("Déconnexion", isPresented: $showLogoutAlert) {
                Button("Annuler", role: .cancel) { }
                Button("Se déconnecter", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Êtes-vous sûr de vouloir vous déconnecter?")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
