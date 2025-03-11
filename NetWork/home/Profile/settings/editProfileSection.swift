//
//  editProfileSection.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/8/25.
//

import SwiftUI

struct EditProfileSection: View {
    //these need to be @Binding because this needs to connect to parent view
    @Binding var isEditingProfile: Bool
    @Binding var name: String
    @Binding var UTR: Double
    @Binding var USTA: Double
    @Binding var usualSpot: String
    @Binding var bio: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var usualSpotCharacterLimit: Int = 25
    @State private var bioCharacterLimit: Int = 150
    
    var isSaveDisabled: Bool {
        return usualSpot.count > usualSpotCharacterLimit || bio.count > bioCharacterLimit
    }

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
                        TextField("First Last", text: $name) //passing the binding
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("UTR:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("1-16", text: Binding(
                            get: { UTR > 0 ? String(format: "%.1f", UTR) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 16.0 { // only accepts certain range
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
                                if let value = Double(newValue), value >= 1.0, value <= 6.0 { // only accepts certain range
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
                        /*
                            .onChange(of: usualSpot) { oldValue, newValue in
                                if newValue.count > usualSpotCharacterLimit {
                                    usualSpot = String(newValue.prefix(usualSpotCharacterLimit))
                                }
                            }
                         */
                    }
                                                       

                    VStack(alignment: .leading) {
                        TextEditor(text: $bio)
                            .frame(width: 300)
                            .padding (10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.system(size: 15))
                        /*
                            .onChange(of: bio) { oldValue, newValue in
                                if newValue.count > bioCharacterLimit {
                                    bio = String(newValue.prefix(bioCharacterLimit))
                                }
                            }
                         */
                        
                    }

                    Button(action: {
                        
                        Task {
                            do {
                                // Stops empty fields from being displayed as the update
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
                    .disabled(isSaveDisabled)
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
