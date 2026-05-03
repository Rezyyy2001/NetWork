//
//  SettingsViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/13/26.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject, UserProfileDataProvider {
    
    @Published var isEditingProfile: Bool = false
    
    @Published var displayName: String = ""
    @Published var utr: Double? = 0.0
    @Published var usta: Double? = 0.0
    @Published var usualSpot: String? = nil
    @Published var bio: String? = nil
    @Published var age: Int = 0
    
    @Published var uid: String = ""
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let service = CurrentUserService.shared

    func fetchCurrentUserProfile() async {
        do {
            let profile = try await service.fetchUserProfile()
            apply(profile)
        } catch {
            self.errorMessage = "Could not find user"
        }
    }
    
    func signOut() {
        do {
            try AuthenticationManager.shared.signOut()
        } catch {
            self.errorMessage = "Error signing out: \(error.localizedDescription)"
            self.showErrorAlert = true
        }
    }
    
    // EditProfileSection will be using this function
    func saveProfile() async {
        do {
            try await service.updateProfile(
                name: displayName,
                UTR: utr ?? 0.0,
                USTA: usta ?? 0.0,
                usualSpot: usualSpot ?? "",
                bio: bio ?? ""
            )
            self.isEditingProfile = false
        } catch {
            self.errorMessage = "Could not save profile"
        }
    }
}
