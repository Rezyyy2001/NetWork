//
//  settingsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/16/25.
//

import SwiftUI
import Foundation

class AuthState: ObservableObject {
    @Published var isAuthenticated: Bool = true
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authState: AuthState // Access the global auth state

    var body: some View {
        NavigationStack {
            List {
                Button(role: .destructive) {
                    do {
                        try AuthenticationManager.shared.signOut()
                        authState.isAuthenticated = false // Set to false to trigger transition
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.red)
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }

                Button(action: {
                    dismiss() // Dismiss the view when "Cancel" is tapped
                }) {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.blue)
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
