//
//  GarageDetailView.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

struct GarageDetailView: View {
    @EnvironmentObject var garageViewModel: GarageViewModel
    let garage: GarageResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Card
                VStack(alignment: .leading, spacing: 16) {
                    Text(garage.nom)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(garage.noteUtilisateur) ? "star.fill" : "star")
                                .foregroundColor(.accentYellow)
                        }
                        
                        Text(String(format: "%.1f", garage.noteUtilisateur))
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.accentBlue)
                            Text(garage.adresse)
                                .font(.subheadline)
                                .foregroundColor(.textPrimary)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.accentGreen)
                            
                            Button {
                                if let url = URL(string: "tel://\(garage.telephone)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text(garage.telephone)
                                    .font(.subheadline)
                                    .foregroundColor(.deepPurple)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Services Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Services proposés")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    FlowLayout(spacing: 8) {
                        ForEach(garage.typeService, id: \.self) { service in
                            Text(service)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.deepPurple.opacity(0.1))
                                .foregroundColor(.deepPurple)
                                .cornerRadius(8)
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
                        if let url = URL(string: "tel://\(garage.telephone)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Appeler")
                        }
                        .primaryButton()
                    }
                    
                    Button {
                        // Open Maps
                        let address = garage.adresse.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: "maps://?q=\(address)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Itinéraire")
                        }
                        .secondaryButton()
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(Color.softWhite)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Flow Layout for Services
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for size in sizes {
            if lineWidth + size.width > proposal.width ?? 0 {
                totalHeight += lineHeight + spacing
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            totalWidth = max(totalWidth, lineWidth)
        }
        
        totalHeight += lineHeight
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for index in subviews.indices {
            if lineX + sizes[index].width > bounds.maxX {
                lineY += lineHeight + spacing
                lineHeight = 0
                lineX = bounds.minX
            }
            
            subviews[index].place(
                at: CGPoint(x: lineX, y: lineY),
                proposal: ProposedViewSize(sizes[index])
            )
            
            lineHeight = max(lineHeight, sizes[index].height)
            lineX += sizes[index].width + spacing
        }
    }
}

struct GarageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GarageDetailView(garage: GarageResponse(
                id: "1",
                nom: "Garage Central",
                adresse: "123 Rue de Paris, 75001 Paris",
                typeService: ["vidange", "révision", "pneus", "freins"],
                telephone: "0123456789",
                noteUtilisateur: 4.5,
                createdAt: nil,
                updatedAt: nil
            ))
            .environmentObject(GarageViewModel())
        }
    }
}
