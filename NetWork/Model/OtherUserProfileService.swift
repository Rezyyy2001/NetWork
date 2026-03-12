//
//  OtherUserProfileService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/9/26.
//

import Foundation
import Firebase

final class OtherUserProfileService {
    private let db = Firestore.firestore()
    
    func fetchUserProfile(userID: String) async throws -> UserProfile {
        let document = try await db.collection("users").document(userID).getDocument()
        
        guard let data = document.data() else {
            throw NSError(domain: "User profile not found.", code: 404, userInfo: nil)
        }
        
        let timestamp = data["birthday"] as? Timestamp
        let birthday = timestamp?.dateValue()
        
        return UserProfile(
            name: data["name"] as? String ?? "",
            UTR: data["UTR"] as? Double ?? 0.0,
            USTA: data["USTA"] as? Double ?? 0.0,
            usualSpot: data["usualSpot"] as? String ?? "",
            bio: data["bio"] as? String ?? "",
            birthday: birthday
        )
    }
}
