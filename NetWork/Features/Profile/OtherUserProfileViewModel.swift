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
    
    var name: String {
        displayName
    }
    
    // Needs an init to know what user to fetch
    init(userID: String) {
        self.userID = userID
        fetchUserProfile(for: userID)
    }
     
    func fetchUserProfile(for userID: String) {
        Task {
            do {
                let profile = try await service.fetchUserProfile(userID: userID)
                
                self.displayName = profile.name
                self.bio = profile.bio
                self.usualSpot = profile.usualSpot
                self.utr = profile.UTR
                self.usta = profile.USTA
                if let birthday = profile.birthday {
                    self.age = birthday.age
                }
            } catch {
                self.errorMessage = "Could not find user"
            }
        }
    }
}
