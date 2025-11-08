//
//  karhebti_iosApp.swift
//  karhebti-ios
//
//  Created by aziz on 06/11/2025.
//

import SwiftUI
import AuthenticationServices
@main
struct karhebti_iosApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
