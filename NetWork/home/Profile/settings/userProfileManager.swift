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
    private init() {}

    // Update profile information in Firebase Auth and Firestore
    func updateProfile(name: String, utr: Double, usta: Double, favoriteSpot: String, bio: String) async throws -> User {
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
            "utr": utr,
            "usta": usta,
            "favoriteSpot": favoriteSpot,
            "bio": bio
        ]
        try await Firestore.firestore().collection("users").document(user.uid).updateData(userData)

        // Reload the user to ensure updated data is reflected
        try await user.reload()
        return Auth.auth().currentUser!
    }

    // Fetch user profile data from Firestore
    func fetchUserProfile(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)))
            return
        }

        Firestore.firestore().collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = snapshot?.data() {
                completion(.success(data))
            }
        }
    }
}

