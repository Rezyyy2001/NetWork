//
//  UserProfile.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/10/26.
//

import Foundation

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
}

struct HitRequestProfile {
    let documentID: String
    let userProfile: UserProfile
    let status: HitRequestStatus
}


