//
//  UserProfile.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/10/26.
//

import Swift
import Firebase

struct UserProfile {
    
    let name: String
    let UTR: Double
    let USTA: Double
    let usualSpot: String?
    let bio: String?
    let birthday: Date?
    let profilePictureURL: String?
    
    var age: Int? {
            guard let birthday = birthday else { return nil }
            return birthday.age
    }
    
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

struct HitRequestProfile {
    let documentID: String
    let userProfile: UserProfile
    let status: HitRequestStatus
}


