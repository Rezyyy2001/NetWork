//
//  editProfileSection.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/8/25.
//

import SwiftUI

struct EditProfileSection: View {
    @Binding var isEditingProfile: Bool
    @Binding var name: String
    @Binding var utr: Double
    @Binding var usta: Double
    @Binding var favoriteSpot: String
    @Binding var bio: String

    var body: some View {
        Section {
            Button(action: {
                withAnimation {
                    isEditingProfile.toggle()
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

                    TextField("UTR (1-16)", text: Binding(
                        get: { String(format: "%.1f", utr) },
                        set: { if let value = Double($0) { utr = min(max(value, 1.0), 16.0) } }
                    ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("USTA (1-5)", text: Binding(
                        get: { String(format: "%.1f", usta) },
                        set: { if let value = Double($0) { usta = min(max(value, 1.0), 5.0) } }
                    ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Favorite Spot", text: $favoriteSpot)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Biography", text: $bio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        Task {
                            do {
                                let updatedUser = try await UserProfileManager.shared.updateProfile(
                                    name: name,
                                    utr: utr,
                                    usta: usta,
                                    favoriteSpot: favoriteSpot,
                                    bio: bio
                                )

                                // Immediately reflect the updated name in UI
                                self.name = updatedUser.displayName ?? name
                                isEditingProfile = false
                            } catch {
                                print("Error updating profile: \(error.localizedDescription)")
                            }
                        }
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
    }
}
