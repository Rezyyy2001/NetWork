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
    
    var age: Int? {
            guard let birthday = birthday else { return nil }
            return birthday.age
    }
    
    static func from(_ data: [String: Any]) -> UserProfile {
        let timestamp = data["birthday"] as? Timestamp
        
        return UserProfile(
            name: data["name"] as? String ?? "",
            UTR: data["UTR"] as? Double ?? 0.0,
            USTA: data["USTA"] as? Double ?? 0.0,
            usualSpot: data["usualSpot"] as? String ?? "",
            bio: data["bio"] as? String ?? "",
            birthday: timestamp?.dateValue()
        )
    }
}


