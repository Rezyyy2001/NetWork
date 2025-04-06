//
//  userProfileDataProvider.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import Foundation

@MainActor
protocol userProfileDataProvider {
    var name: String { get }
    var bio: String? { get }
    var usualSpot: String? { get }
    var utr: Double? { get }
    var usta: Double? { get }
    var age: Int { get }
}
