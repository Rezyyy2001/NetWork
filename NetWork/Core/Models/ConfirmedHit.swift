//
//  ConfirmedHit.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/7/26.
//

import Foundation

struct ConfirmedHit: Identifiable {
    let id: String

    let posterName: String
    
    let posterUTR: Double?
    let posterUSTA: Double?
    let location: String
    let date: Date
    let extraInfo: String
    let numberOfPeople: Int
    let profilePictureURL: String?
    let latitude: Double?
    let longitude: Double?
}
