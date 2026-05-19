//
//  CurrentUserService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class CurrentUserService: Sendable {

    static let shared = CurrentUserService()
    private init() {}

    // Update profile information in Firebase Auth and Firestore
    func updateProfile(name: String, UTR: Double, USTA: Double, usualSpot: String, bio: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()

        let userData: [String: Any] = [
            FirestoreKeys.UserFields.name: name,
            FirestoreKeys.UserFields.utr: UTR,
            FirestoreKeys.UserFields.usta: USTA,
            FirestoreKeys.UserFields.usualSpot: usualSpot,
            FirestoreKeys.UserFields.bio: bio,
            FirestoreKeys.UserFields.nameLowercased: name.lowercased(),
            FirestoreKeys.UserFields.lastNameLowercased: name.components(separatedBy: " ").last?.lowercased() ?? "",
        ]
        try await Firestore.firestore().collection(FirestoreKeys.Collections.users).document(user.uid).updateData(userData)
    }

    // Fetch user profile data from Firestore
    func fetchUserProfile() async throws -> UserProfile {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        let document = try await Firestore.firestore().collection(FirestoreKeys.Collections.users).document(user.uid).getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "User profile not found.", code: 404, userInfo: nil)
        }

        return UserProfile.from(data)
    }

    func createUserProfile(name: String, email: String, birthday: Date?, usualSpot: String) async throws {

        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        let userData: [String: Any] = [
            FirestoreKeys.UserFields.name: name,
            FirestoreKeys.UserFields.nameLowercased: name.lowercased(),
            FirestoreKeys.UserFields.lastNameLowercased: name.components(separatedBy: " ").last?.lowercased() ?? "",
            FirestoreKeys.UserFields.email: email,
            FirestoreKeys.UserFields.uid: user.uid,
            FirestoreKeys.UserFields.birthday: birthday.map { Timestamp(date: $0) } ?? NSNull(),
            FirestoreKeys.UserFields.utr: 0.0,
            FirestoreKeys.UserFields.usta: 0.0,
            FirestoreKeys.UserFields.bio: "",
            FirestoreKeys.UserFields.usualSpot: usualSpot
        ]
        try await Firestore.firestore().collection(FirestoreKeys.Collections.users).document(user.uid).setData(userData)
    }
}
