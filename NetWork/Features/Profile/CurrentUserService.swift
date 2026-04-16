//
//  CurrentUserService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class CurrentUserService {
    
    static let shared = CurrentUserService()
    init() {}

    // Update profile information in Firebase Auth and Firestore
    func updateProfile(name: String, UTR: Double, USTA: Double, usualSpot: String, bio: String) async throws {
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
            "usualSpot": usualSpot,
            "bio": bio,
            "name_lowercased": name.lowercased(),
        ]
        try await Firestore.firestore().collection("users").document(user.uid).updateData(userData)
    
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
        
        return UserProfile.from(data)
    }
    
    func createUserProfile(name: String, email: String, birthday: Date?, usualSpot: String) async throws {

        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }
        
        let userData: [String: Any] = [ // dictionary of user details
            "name": name,
            "name_lowercased": name.lowercased(),
            "email": email,
            "uid": user.uid,
            "birthday": birthday.map { Timestamp(date: $0) } ?? NSNull(), // birthday field as a timestamp
            "UTR": 0.0,
            "USTA": 0.0,
            "bio": "",
            "usualSpot": usualSpot
            
        ]
        try await Firestore.firestore().collection("users").document(user.uid).setData(userData)
    }
}

