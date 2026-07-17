//
//  settingsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/16/25.
//

import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var settingsViewModel: SettingsViewModel
    
    @StateObject private var editServiceViewModel: EditServiceViewModel
    
    init (authState: AuthState) {
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(authState: authState))
        _editServiceViewModel = StateObject(wrappedValue: EditServiceViewModel())
    }
    
    public var body: some View {
        VStack (alignment: .leading) {
            BackButton()

            Text("Settings")
                .font(.largeTitle)
                .padding(.horizontal)
            
            List {
                // the $ allows those variables to change in editProfileSection
                EditProfileSection(viewModel: settingsViewModel)
                
                // EditServiceSection
                EditServiceSection(viewModel: editServiceViewModel)
        
                SignOutButton {
                    settingsViewModel.signOut()
                    dismiss() // So the exit seems seemless
                }
            }
            .navigationTitle("Settings")
            .alert("Error", isPresented: $settingsViewModel.showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(settingsViewModel.errorMessage)
            }
            .task {
                await settingsViewModel.fetchCurrentUserProfile()
            }
        }
    }
}

