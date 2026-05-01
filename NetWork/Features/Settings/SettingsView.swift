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

    @StateObject private var viewModel = SettingsViewModel()
    
    public var body: some View {
        VStack (alignment: .leading) {
            BackButton()

            Text("Settings")
                .font(.largeTitle)
                .padding(.horizontal)
            
            List {
                // the $ allows those variables to change in editProfileSection
                EditProfileSection(viewModel: viewModel)
                
                // Sign Out Section
                Section {
                    Button(role: .destructive) {
                        viewModel.signOut()
                        authState.isAuthenticated = false
                        dismiss() // So the exit seems seemliss
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .foregroundColor(.red)
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .task {
                await viewModel.fetchCurrentUserProfile()
            }
        }
    }
}

