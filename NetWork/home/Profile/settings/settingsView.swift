//
//  settingsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/16/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authState: AuthState

    @State private var isEditingProfile: Bool = false
    @State private var name: String = ""
    @State private var utr: Double = 1.0
    @State private var usta: Double = 1.0
    @State private var favoriteSpot: String = ""
    @State private var bio: String = ""

    var body: some View {
        NavigationStack {
            List {
                // Edit Profile Section
                EditProfileSection(
                    isEditingProfile: $isEditingProfile,
                    name: $name,
                    utr: $utr,
                    usta: $usta,
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
            
            //.onAppear {
              //  fetchUserProfile()
            }
        }
    }
/*
    // Fetch the latest profile data from Firestore when the view appears
    private func fetchUserProfile() {
        UserProfileManager.shared.fetchUserProfile { result in
            switch result {
            case .success(let data):
                self.name = data["name"] as? String ?? ""
                self.utr = data["utr"] as? Double ?? 1.0
                self.usta = data["usta"] as? Double ?? 1.0
                self.favoriteSpot = data["favoriteSpot"] as? String ?? ""
                self.bio = data["bio"] as? String ?? ""
            case .failure(let error):
                print("Error fetching profile: \(error.localizedDescription)")
            }
        }
    }
 */
 
//}
