//
//  userProfileManager.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserProfileManager {
    
    static let shared = UserProfileManager()
    init() {}
    
    struct UserProfile {
        let name: String
        let UTR: Double
        let USTA: Double
        let favoriteSpot: String
        let bio: String
    }

    // Update profile information in Firebase Auth and Firestore
    func updateProfile(name: String, UTR: Double, USTA: Double, favoriteSpot: String, bio: String) async throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        // Update displayName in Firebase Auth
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()

        // Update Firestore data
        let userData: [String: Any] = [
            "name": name,
            "UTR": UTR,
            "USTA": USTA,
            "favoriteSpot": favoriteSpot,
            "bio": bio
        ]
        try await Firestore.firestore().collection("users").document(user.uid).updateData(userData)

        // Reload the user to ensure updated data is reflected
        try await user.reload()
        return Auth.auth().currentUser!
    }

    // Fetch user profile data from Firestore
    func fetchUserProfile() async throws -> UserProfile {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        let document = try await Firestore.firestore().collection("users").document(user.uid).getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "User profile not found.", code: 404, userInfo: nil)
        }

        return UserProfile(
            name: data["name"] as? String ?? "",
            UTR: data["UTR"] as? Double ?? 0.0,
            USTA: data["USTA"] as? Double ?? 0.0,
            favoriteSpot: data["favoriteSpot"] as? String ?? "",
            bio: data["bio"] as? String ?? ""
        )
    }

}

