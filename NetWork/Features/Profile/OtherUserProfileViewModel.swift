//
//  OtherUserProfileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class OtherUserProfileViewModel: ObservableObject, UserProfileDataProvider {
    
    private let service = OtherUserProfileService()
    
    // userProfileDataProvider ensures that the properties are the correct type
    @Published var displayName: String = "Loading..."
    @Published var bio: String? = "No bio available."
    @Published var usualSpot: String? = "Unknown location."
    @Published var utr: Double? = 0.0
    @Published var usta: Double? = 0.0
    @Published var age: Int = 0
    
    @Published var errorMessage: String? = nil

    private let userID: String

    var uid: String {
        userID
    }
    
    // Needs an init to know what user to fetch
    init(userID: String) {
        self.userID = userID
        Task { await fetchUserProfile(for: userID) }
    }

    func fetchUserProfile(for userID: String) async {
        do {
            let profile = try await service.fetchUserProfile(userID: userID)
            apply(profile)
        } catch {
            self.errorMessage = "Could not find user"
        }
    }
}
