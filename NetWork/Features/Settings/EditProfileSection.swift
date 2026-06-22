//
//  editProfileSection.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/8/25.
//

import SwiftUI
import PhotosUI

public struct EditProfileSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    private let usualSpotCharacterLimit = 25
    
    var isSaveDisabled: Bool {
        (viewModel.usualSpot ?? "").count > usualSpotCharacterLimit
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
                        Spacer()
                        Image(systemName: "person")
                            .foregroundColor(Color(red: 30/255, green: 143/255, blue: 213/255))
                            .frame(width: 80, height: 80)
                            .font(.system(size: 35))
                            .overlay(RoundedRectangle(cornerRadius: 40)
                                .stroke(Color(red: 30/255, green: 143/255, blue: 213/255), lineWidth: 2))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $selectedItem) {
                            Text ("Choose Photo")
                        }
                        .buttonStyle(.borderless)
                        Spacer()
                    }
                    .onChange(of: selectedItem) {
                          Task {
                              if let data = try? await selectedItem?.loadTransferable(type:
                      Data.self),
                                 let image = UIImage(data: data) {
                                  viewModel.selectedImage = image
                                }
                          }
                    }
                    
                    HStack {
                        Text("Name:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("First Last", text: $viewModel.displayName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }

                    HStack {
                        Text("UTR:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.gray)
                        TextField("1-16", text: Binding(
                            get: { viewModel.utr ?? 0 > 0 ? String(format: "%.1f", viewModel.utr!) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 16.0 {
                                    viewModel.utr = value
                                } else if newValue.isEmpty {
                                    viewModel.utr = 0
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
                            get: { viewModel.usta ?? 0 > 0 ? String(format: "%.1f", viewModel.usta!) : "" },
                            set: { newValue in
                                if let value = Double(newValue), value >= 1.0, value <= 6.0 {
                                    viewModel.usta = value
                                } else if newValue.isEmpty {
                                    viewModel.usta = 0
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
                        TextField("(25 Character limit)", text: Binding(
                            get: { viewModel.usualSpot ?? "" },
                            set: { viewModel.usualSpot = $0 }
                        ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        CustomTextbox(
                            text: Binding(
                                get: { viewModel.bio ?? "" },
                                set: { viewModel.bio = $0 }
                            ),
                            placeholder: "Write a short bio about yourself",
                            characterLimit: 300
                        )
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

