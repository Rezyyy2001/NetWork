//
//  profileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject, UserProfileDataProvider {
    // UI State
    @Published var showSettings = false
    @Published var showFriendRequests = false
    @Published var showMessageView = false
    @Published var errorMessage: String? = nil

    // Auth info
    @Published var user: AuthDataResultModel? = nil
    @Published var uid: String = ""

    // Profile data
    @Published var utr: Double? = nil
    @Published var usta: Double? = nil
    @Published var bio: String? = nil
    @Published var usualSpot: String? = nil
    @Published var age: Int = 0

    var name: String {
        user?.displayName ?? "Unknown"
    }

    init() {
        if let currentUser = Auth.auth().currentUser {
            self.uid = currentUser.uid
            Task { await fetchUserProfile() }
        } else {
            self.errorMessage = "No user logged in."
        }
    }

    func fetchUserProfile() async {
        do {
            let (userData, fetchedUTR, fetchedUSTA, fetchedBio, fetchedUsualSpot, birthday) =
                try await AuthenticationManager.shared.getUserProfile()

            self.user = userData
            self.utr = fetchedUTR
            self.usta = fetchedUSTA
            self.bio = fetchedBio
            self.usualSpot = fetchedUsualSpot

            if let birthdate = birthday {
                self.age = birthdate.age
            }
        } catch {
            self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
        }
    }
}




