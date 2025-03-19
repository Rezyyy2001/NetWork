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
    @State private var usualSpot: String = ""
    @State private var bio: String = ""

    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    public var body: some View {
        NavigationStack {
            List {
                // the $ allows those variables to change in editProfileSection
                EditProfileSection(
                    isEditingProfile: $isEditingProfile,
                    name: $name,
                    UTR: $UTR,
                    USTA: $USTA,
                    usualSpot: $usualSpot,
                    bio: $bio
                )

                // Sign Out Section
                Section {
                    Button(role: .destructive) {
                        Task {
                            do {
                                try AuthenticationManager.shared.signOut()
                                authState.isAuthenticated = false
                            } catch {
                                errorMessage = "Error signing out: \(error.localizedDescription)"
                                showErrorAlert = true
                            }
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
                    Button(action: { dismiss() }) {
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
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .task {
                await loadUserProfile()
            }
        }
    }

    private func loadUserProfile() async {
        do {
            let (userData, fetchedUTR, fetchedUSTA, fetchedBio, fetchedUsualSpot) = try await AuthenticationManager.shared.getUserProfile()
            name = userData.displayName ?? ""
            UTR = fetchedUTR ?? 0.0
            USTA = fetchedUSTA ?? 0.0
            bio = fetchedBio ?? ""
            usualSpot = fetchedUsualSpot ?? ""
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
