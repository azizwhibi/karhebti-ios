//
//  TokenManager.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import Foundation
import Security

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "com.karhebti.authToken"
    private let userKey = "com.karhebti.userData"
    
    private init() {}
    
    // MARK: - Token Management (Keychain)
    func saveToken(_ token: String) {
        saveToKeychain(key: tokenKey, value: token)
    }
    
    func getToken() -> String? {
        return getFromKeychain(key: tokenKey)
    }
    
    // MARK: - User Data Management (UserDefaults)
    func saveUser(_ user: UserData) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func getUser() -> UserData? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(UserData.self, from: data) else {
            return nil
        }
        return user
    }
    
    // MARK: - Logout
    func clearAll() {
        deleteFromKeychain(key: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    func isLoggedIn() -> Bool {
        return getToken() != nil && getUser() != nil
    }
    
    // MARK: - Keychain Helpers
    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Delete existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - UserData Model
struct UserData: Codable {
    let id: String?
    let email: String
    let nom: String
    let prenom: String
    let role: String
    let telephone: String?
}
