//
//  HitPost.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/14/26.
//

import Foundation

struct HitPost: Identifiable {
    let id: String

    let userID: String
    let posterName: String
    let posterUTR: Double?
    let posterUSTA: Double?
    let location: String
    let city: String
    let date: Date
    let extraInfo: String
    let numberOfPeople: Int
    let isPublic: Bool
    let profilePictureURL: String?
    let latitude: Double?
    let longitude: Double?
}
