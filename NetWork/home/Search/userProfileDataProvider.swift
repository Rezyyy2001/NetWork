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
protocol UserProfileDataProvider {
    var name: String { get }
    var bio: String? { get }
    var usualSpot: String? { get }
    var utr: Double? { get }
    var usta: Double? { get }
    var age: Int { get }
    var uid: String { get }
}
