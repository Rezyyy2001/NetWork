//
//  settingsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/16/25.
//

import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authState: AuthState

    @State private var isEditingProfile: Bool = false
    @State private var name: String = ""
    @State private var UTR: Double = 0.0
    @State private var USTA: Double = 0.0
    @State private var favoriteSpot: String = ""
    @State private var bio: String = ""

    public var body: some View {
        NavigationStack {
            List {
                // Edit Profile Section
                EditProfileSection(
                    isEditingProfile: $isEditingProfile,
                    name: $name,
                    UTR: $UTR,
                    USTA: $USTA,
                    favoriteSpot: $favoriteSpot,
                    bio: $bio
                )

                // Sign Out Section
                Section {
                    Button(role: .destructive) {
                        do {
                            try AuthenticationManager.shared.signOut()
                            authState.isAuthenticated = false
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
                }

                // Cancel Button Section
                Section {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.blue)
                            Text("Cancel")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
#Preview {
    NavigationStack {
        SettingsView()
    }
}
