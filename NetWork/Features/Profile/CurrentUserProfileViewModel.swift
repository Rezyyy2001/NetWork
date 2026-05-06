//
//  CurrentUserProfileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class CurrentUserProfileViewModel: ObservableObject, UserProfileDataProvider {
    
    private let service = CurrentUserService.shared
    
    // UI State
    @Published var showSettings = false
    @Published var showFriendRequests = false
    @Published var showMessageView = false
    @Published var errorMessage: String? = nil

    // Auth info
    @Published var uid: String = ""

    // Profile data
    @Published var displayName: String = "Loading..."
    @Published var bio: String? = "No bio available."
    @Published var usualSpot: String? = "Unknown location."
    @Published var utr: Double? = 0.0
    @Published var usta: Double? = 0.0
    @Published var age: Int = 0
    
    init() {
        if let currentUser = Auth.auth().currentUser {
            self.uid = currentUser.uid
            Task { await fetchCurrentUserProfile() }
        } else {
            self.errorMessage = "No user logged in."
        }
    }

    func fetchCurrentUserProfile() async {
        do {
            let profile = try await service.fetchUserProfile()
            apply(profile)
        } catch {
            self.errorMessage = "Could not find user"
        }
    }
}
