//
//  editProfileSection.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/8/25.
//

import SwiftUI

public struct EditProfileSection: View {
    // Public initializer to allow access from SettingsView
    public init(
        isEditingProfile: Binding<Bool>,
        name: Binding<String>,
        UTR: Binding<Double>,
        USTA: Binding<Double>,
        usualSpot: Binding<String>,
        bio: Binding<String>
    ) {
        self._isEditingProfile = isEditingProfile
        self._name = name
        self._UTR = UTR
        self._USTA = USTA
        self._usualSpot = usualSpot
        self._bio = bio
    }
    
    // These need to be @Binding to connect to settingView
    // when EditProfileView changes these variables it will change in settingsView
    @Binding public var isEditingProfile: Bool
    @Binding public var name: String
    @Binding public var UTR: Double
    @Binding public var USTA: Double
    @Binding public var usualSpot: String
    @Binding public var bio: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let usualSpotCharacterLimit = 25
    private let bioCharacterLimit = 150
    
    var isSaveDisabled: Bool {
        usualSpot.count > usualSpotCharacterLimit || bio.count > bioCharacterLimit
    }

    public var body: some View {
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
                        TextField("First Last", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
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
                        Text("Tennis Court")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("(25 Character limit)", text: $usualSpot)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading) {
                        TextField("Hint", text: $bio, axis: .vertical)
                            .frame(width: 300)
                            .padding(10)
                            .lineLimit(100)
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
                                let updatedUsualSpot = usualSpot.isEmpty ? currentUserProfile.usualSpot : usualSpot
                                let updatedBio = bio.isEmpty ? currentUserProfile.bio : bio

                                let updatedUser = try await UserProfileManager.shared.updateProfile(
                                    name: updatedName,
                                    UTR: updatedUTR,
                                    USTA: updatedUSTA,
                                    usualSpot: updatedUsualSpot,
                                    bio: updatedBio
                                )

                                self.name = updatedUser.displayName ?? name
                                self.UTR = updatedUTR
                                self.USTA = updatedUSTA
                                self.usualSpot = updatedUsualSpot
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
                    .buttonStyle(PlainButtonStyle()) // Prevents default button padding
                    .contentShape(Rectangle()) // Ensures only the button’s visible content is tappable
                    .disabled(isSaveDisabled)
                }
                .padding(.vertical)
            }
        }
    }
}

