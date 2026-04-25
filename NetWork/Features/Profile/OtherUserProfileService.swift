//
//  OtherUserProfileService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/9/26.
//

import Foundation
@preconcurrency import Firebase

final class OtherUserProfileService: Sendable {
    private let db = Firestore.firestore()
    
    func fetchUserProfile(userID: String) async throws -> UserProfile {
        let document = try await db.collection("users").document(userID).getDocument()
        
        guard let data = document.data() else {
            throw NSError(domain: "User profile not found.", code: 404, userInfo: nil)
        }
        
        return UserProfile.from(data)
    }
}
