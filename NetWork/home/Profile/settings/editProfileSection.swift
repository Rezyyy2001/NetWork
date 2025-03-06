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
    @Binding var UTR: Double
    @Binding var USTA: Double
    @Binding var favoriteSpot: String
    @Binding var bio: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                    HStack {
                        Text("Name:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("Enter Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("UTR:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("1-16", text: Binding(
                            get: { UTR > 0 ? String(format: "%.1f", UTR) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 16.0 {
                                    UTR = value
                                } else if newValue.isEmpty {
                                    UTR = 0
                                }
                            }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("USTA:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("1-6", text: Binding(
                            get: { USTA > 0 ? String(format: "%.1f", USTA) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 6.0 {
                                    USTA = value
                                } else if newValue.isEmpty {
                                    USTA = 0
                                }
                            }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("Favorite Spot:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("Best court for you", text: $favoriteSpot)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading) {
                        /*
                        Text("Biography:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("Enter Biography", text: $bio)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                         */
                        TextEditor(text: $bio)
                            .frame(width: 300)
                            .padding (10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.system(size: 15))
                    }

                    Button(action: {
                        
                        Task {
                            do {
                                let currentUserProfile = try await UserProfileManager.shared.fetchUserProfile()
                                
                                let updatedName = name.isEmpty ? currentUserProfile.name : name
                                let updatedUTR = UTR == 0 ? currentUserProfile.UTR : UTR
                                let updatedUSTA = USTA == 0 ? currentUserProfile.USTA : USTA
                                let updatedFavoriteSpot = favoriteSpot.isEmpty ? currentUserProfile.favoriteSpot : favoriteSpot
                                let updatedBio = bio.isEmpty ? currentUserProfile.bio : bio

                                let updatedUser = try await UserProfileManager.shared.updateProfile(
                                    name: updatedName,
                                    UTR: updatedUTR,
                                    USTA: updatedUSTA,
                                    favoriteSpot: updatedFavoriteSpot,
                                    bio: updatedBio
                                )
                                
                                self.name = updatedUser.displayName ?? name
                                self.UTR = updatedUTR
                                self.USTA = updatedUSTA
                                self.favoriteSpot = updatedFavoriteSpot
                                self.bio = updatedBio
                                
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
#Preview {
    NavigationStack {
        SettingsView()
    }
}
