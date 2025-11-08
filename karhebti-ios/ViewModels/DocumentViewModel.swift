//
//  DocumentViewModel.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI
import Combine

@MainActor
class DocumentViewModel: ObservableObject {
    @Published var documents: [DocumentResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedDocument: DocumentResponse?
    
    private let apiClient = APIClient.shared
    
    // MARK: - Fetch All Documents
    func fetchDocuments() async {
        isLoading = true
        errorMessage = nil
        
        do {
            documents = try await apiClient.request(endpoint: "documents", method: .get)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Fetch Documents for Vehicle
    func fetchDocuments(forVehicleId vehicleId: String) -> [DocumentResponse] {
        return documents.filter { $0.voiture == vehicleId }
    }
    
    // MARK: - Create Document
    func createDocument(_ request: CreateDocumentRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let newDocument: DocumentResponse = try await apiClient.request(
                endpoint: "documents",
                method: .post,
                body: request
            )
            documents.append(newDocument)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Update Document
    func updateDocument(id: String, request: UpdateDocumentRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedDocument: DocumentResponse = try await apiClient.request(
                endpoint: "documents/\(id)",
                method: .patch,
                body: request
            )
            if let index = documents.firstIndex(where: { $0.id == id }) {
                documents[index] = updatedDocument
            }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Delete Document
    func deleteDocument(id: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let _: MessageResponse = try await apiClient.request(
                endpoint: "documents/\(id)",
                method: .delete
            )
            documents.removeAll { $0.id == id }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
