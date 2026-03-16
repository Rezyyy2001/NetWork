//
//  SettingsViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/13/26.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var isEditingProfile: Bool = false
    @Published var name: String = ""
    @Published var UTR: Double = 0.0
    @Published var USTA: Double = 0.0
    @Published var usualSpot: String = ""
    @Published var bio: String = ""
    @Published var age: Int = 0
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let service = CurrentUserService()
    
    func fetchCurrentUserProfile() async {
        do {
            let profile = try await service.fetchUserProfile()
            
            self.name = profile.name
            self.bio = profile.bio ?? ""
            self.usualSpot = profile.usualSpot ?? ""
            self.UTR = profile.UTR
            self.USTA = profile.USTA
            if let birthday = profile.birthday {
                self.age = birthday.age
            }
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
                name: name,
                UTR: UTR,
                USTA: USTA,
                usualSpot: usualSpot,
                bio: bio
            )
            self.isEditingProfile = false
        } catch {
            self.errorMessage = "Could not save profile"
        }
    }
}
