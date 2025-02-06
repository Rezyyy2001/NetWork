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
    @EnvironmentObject var authState: AuthState

    @State private var isEditingProfile: Bool = false // Toggle for dropdown visibility
    @State private var name: String = "" // Example text fields
    @State private var UTR: String = ""
    @State private var USTA: String = ""
    @State private var favoriteSpot: String = ""
    @State private var bio: String = ""
    

    var body: some View {
        NavigationStack {
            List {
                // Profile Edit Dropdown Section
                Section {
                    Button(action: {
                        withAnimation {
                            isEditingProfile.toggle() // Toggle dropdown visibility
                        }
                    }) {
                        HStack {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.blue)
                            Text("Edit Profile")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: isEditingProfile ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if isEditingProfile {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("UTR", text: $UTR)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("USTA", text: $USTA)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Favorite Spot", text: $favoriteSpot)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Biography", text: $bio)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                // Save action for profile updates
                                print("Profile Updated: \(name), \(UTR), \(bio)")
                                isEditingProfile = false
                            }) {
                                Text("Save")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.vertical)
                    }
                }

                // Sign Out Button
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

                // Cancel Button
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
    SettingsView().environmentObject(AuthState())
}

