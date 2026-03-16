//
//  editProfileSection.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/8/25.
//

import SwiftUI

public struct EditProfileSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    private let usualSpotCharacterLimit = 25
    
    var isSaveDisabled: Bool {
        viewModel.usualSpot.count > usualSpotCharacterLimit
    }

    public var body: some View {
        Section {
            Button(action: {
                withAnimation {
                    viewModel.isEditingProfile.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.blue)
                    Text("Edit Profile")
                        .foregroundColor(.blue)
                    Spacer()
                    Image(systemName: viewModel.isEditingProfile ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }

            if viewModel.isEditingProfile {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Name:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("First Last", text: $viewModel.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }

                    HStack {
                        Text("UTR:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("1-16", text: Binding(
                            get: { viewModel.UTR > 0 ? String(format: "%.1f", viewModel.UTR) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 16.0 {
                                    viewModel.UTR = value
                                } else if newValue.isEmpty {
                                    viewModel.UTR = 0
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
                            get: { viewModel.USTA > 0 ? String(format: "%.1f", viewModel.USTA) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 6.0 {
                                    viewModel.USTA = value
                                } else if newValue.isEmpty {
                                    viewModel.USTA = 0
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
                        TextField("(25 Character limit)", text: $viewModel.usualSpot)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        LimitedLineTextEditor(
                            text: $viewModel.bio,
                            placeholder: "Write a short bio about yourself",
                            lineLimit: 11
                        )
                        .frame(width: 325)

                    }

                    Button(action: {
                        Task { await viewModel.saveProfile()}
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

