//
//  settingsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/16/25.
//

import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: SettingsViewModel
    
    init (authState: AuthState) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(authState: authState))
    }
    
    public var body: some View {
        VStack (alignment: .leading) {
            BackButton()

            Text("Settings")
                .font(.largeTitle)
                .padding(.horizontal)
            
            List {
                // the $ allows those variables to change in editProfileSection
                EditProfileSection(viewModel: viewModel)
        
                SignOutButton {
                    viewModel.signOut()
                    dismiss() // So the exit seems seemliss
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

