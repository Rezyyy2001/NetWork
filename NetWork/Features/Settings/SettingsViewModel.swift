//
//  SettingsViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/13/26.
//

import Foundation
import FirebaseStorage
import UIKit
import FirebaseAuth

@MainActor
final class SettingsViewModel: ObservableObject, UserProfileDataProvider {
    
    @Published var isEditingProfile: Bool = false
    
    @Published var displayName: String = ""
    @Published var utr: Double? = 0.0
    @Published var usta: Double? = 0.0
    @Published var usualSpot: String? = nil
    @Published var bio: String? = nil
    @Published var age: Int = 0
    @Published var profilePictureURL: String? = nil
    
    @Published var uid: String = ""
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    @Published var selectedImage: UIImage? = nil
    
    private let service = CurrentUserService.shared
    
    private let authState: AuthState
    
    init(authState: AuthState) {
        self.authState = authState
    }

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
            authState.isAuthenticated = false
        } catch {
            self.errorMessage = "Error signing out: \(error.localizedDescription)"
            self.showErrorAlert = true
        }
    }
    
    // EditProfileSection will be using this function
    func saveProfile() async {
        do {
            let photoURL = await changePhoto() ?? ""
            
            try await service.updateProfile(
                name: displayName,
                UTR: utr ?? 0.0,
                USTA: usta ?? 0.0,
                usualSpot: usualSpot ?? "",
                bio: bio ?? "",
                profilePictureURL: photoURL
            )
            self.isEditingProfile = false
        } catch {
            self.errorMessage = "Could not save profile"
        }
    }
    
    func changePhoto() async -> String? {
        guard let image = selectedImage,
              let data = image.jpegData(compressionQuality: 0.8) else {
                return profilePictureURL }
        let storageRef = Storage.storage().reference().child("users/\(Auth.auth().currentUser?.uid ?? "").jpg")
        do {
            _ = try? await storageRef.putDataAsync(data)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            return nil
        }
    }
}
