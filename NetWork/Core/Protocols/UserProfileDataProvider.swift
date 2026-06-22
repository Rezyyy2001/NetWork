//
//  userProfileDataProvider.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import Foundation

// if a struct or class conforms to userProfileDataProvider, it must follow these methods or properties.
// so if a struct conforms to userProfileDataProvider, name needs to be a string, bio needs to be an optional string, etc
@MainActor
protocol UserProfileDataProvider: AnyObject {
    var displayName: String { get set }
    var bio: String? { get set }
    var usualSpot: String? { get set }
    var utr: Double? { get set }
    var usta: Double? { get set }
    var age: Int { get set }
    var uid: String { get }
    var profilePictureURL: String? { get set }
}

extension UserProfileDataProvider {
    func apply(_ profile: UserProfile) {
        displayName = profile.name
        bio = profile.bio
        usualSpot = profile.usualSpot
        utr = profile.UTR
        usta = profile.USTA
        age = profile.birthday?.age ?? 0
        profilePictureURL = profile.profilePictureURL
    }
}
