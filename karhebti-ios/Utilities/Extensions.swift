//
//  Extensions.swift
//  karhebti-ios
//
//  Created on 06/11/2025.
//

import SwiftUI

// MARK: - Date Extensions
extension Date {
    func formatted(_ format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: self)
    }
    
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

// MARK: - Color Extensions
extension Color {
    // Main Colors
    static let deepPurple = Color(red: 0.4, green: 0.35, blue: 0.87) // #6658DD
    static let softWhite = Color(red: 0.98, green: 0.98, blue: 0.98) // #FAFAFA
    static let lightPurple = Color(red: 0.92, green: 0.92, blue: 0.996) // #EBEAFE
    
    // Accent Colors
    static let accentGreen = Color(red: 0, green: 0.78, blue: 0.59) // #00C896
    static let accentBlue = Color(red: 0.13, green: 0.59, blue: 0.95) // #2196F3
    static let accentOrange = Color(red: 1, green: 0.6, blue: 0) // #FF9800
    static let alertRed = Color(red: 0.86, green: 0.21, blue: 0.27) // #DC3545
    static let accentYellow = Color(red: 1, green: 0.76, blue: 0.03) // #FFC107
    
    // Grey Scale
    static let lightGrey = Color(red: 0.88, green: 0.88, blue: 0.88) // #E0E0E0
    static let mediumGrey = Color(red: 0.62, green: 0.62, blue: 0.62) // #9E9E9E
    static let darkGrey = Color(red: 0.38, green: 0.38, blue: 0.38) // #616161
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1) // #1A1A1A
    static let textSecondary = Color(red: 0.38, green: 0.38, blue: 0.38) // #616161
    
    // Status Colors
    static let statusGood = Color.accentGreen
    static let statusAttention = Color.accentYellow
    static let statusUrgent = Color.alertRed
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func primaryButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.deepPurple)
            .cornerRadius(12)
    }
    
    func secondaryButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(.deepPurple)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.deepPurple, lineWidth: 2)
            )
    }
}

// MARK: - String Extensions
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
