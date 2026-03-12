//
//  UserProfile.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/10/26.
//

import Swift
import Foundation

struct UserProfile {
    let name: String
    let UTR: Double
    let USTA: Double
    let usualSpot: String
    let bio: String
    let birthday: Date?
    
    var age: Int? {
            guard let birthday = birthday else { return nil }
            return birthday.age
    }
}
