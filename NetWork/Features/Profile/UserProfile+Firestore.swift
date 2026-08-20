//
//  UserProfile+Firestore.swift
//  NetWork
//
//  Created by Rezka Yuspi on 8/20/26.
//

import Foundation
@preconcurrency import FirebaseFirestore

extension UserProfile {
    static func from(_ data: [String: Any]) -> UserProfile {
        let timestamp = data[FirestoreKeys.UserFields.birthday] as? Timestamp

        return UserProfile(
            name: data[FirestoreKeys.UserFields.name] as? String ?? "",
            UTR: data[FirestoreKeys.UserFields.utr] as? Double ?? 0.0,
            USTA: data[FirestoreKeys.UserFields.usta] as? Double ?? 0.0,
            usualSpot: data[FirestoreKeys.UserFields.usualSpot] as? String,
            bio: data[FirestoreKeys.UserFields.bio] as? String,
            birthday: timestamp?.dateValue(),
            profilePictureURL: data[FirestoreKeys.UserFields.profilePictureURL] as? String
        )
    }
}
