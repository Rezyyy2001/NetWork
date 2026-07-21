//
//  BusinessCard.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/12/26.
//

import Foundation

struct BusinessCard: Identifiable {
    let id: String
    let userID: String
    let isActive: Bool
    
    let serviceType: ServiceType
    let pricing: Int
    
    let city: String
    let likeCount: Int
    
    let description: String
    let tags: [ServiceTag]

    let phoneNumber: String?
    let email: String?
    let insta: String?
    
    let cardName: String
    let profilePicture: String?
    let backgroundPic: String?
}

enum ServiceType: String, Codable, CaseIterable {
    case stringing = "Stringing"
    case lessons = "Lessons"
    case paidHit = "Paid Hit"
    
    var icon: String {
        switch self {
        case .stringing: return "tennis.racket"
        case .lessons: return "figure.tennis"
        case .paidHit: return "tennisball"
        }
    }
    
    var availableTags: [ServiceTag] {
        switch self {
        case .stringing: return [.fiveYears, .tenYears, .twentyFourHour, .walkInsOnly, .mobile, .dropWeight, .manualCrank, .electronic, .bulkDiscount, .freeTrial]
        case .lessons, .paidHit: return [.beginnerFriendly, .advancedPlayer, .rally, .juniors, .adults, .privateLessons, .groupLessons, .weekends, .weekdays, .english, .mandarin, .spanish, .clubAffiliated, .publicCourts, .certifiedCoach, .collegeTennis, .highSchoolTennis, .middleSchoolTennis, .d1, .d2, .d3]
        }
    }
}

enum ServiceTag: String, Codable, CaseIterable {
    // MARK: Chips for private lessons and paid hits
    case beginnerFriendly = "Beginner Friendly"
    case advancedPlayer = "Advanced Player"
    case rally = "Rally"
    
    case juniors = "Juniors"
    case adults = "Adults"
    case privateLessons = "Private Lessons"
    case groupLessons = "Group Lessons"
    
    case weekends = "Weekends"
    case weekdays = "Weekdays"
    
    case english = "English"
    case mandarin = "Mandarin"
    case spanish = "Spanish"
    
    case clubAffiliated = "Club Affiliated"
    case publicCourts = "Public Courts"
    case certifiedCoach = "Certified Coach"
    
    case collegeTennis = "College Tennis"
    case highSchoolTennis = "High School Tennis"
    case middleSchoolTennis = "Middle School Tennis"
    
    case d1 = "D1"
    case d2 = "D2"
    case d3 = "D3"
   
    //MARK: chips for Stringing
    case fiveYears = "5 years"
    case tenYears = "10 years"
    case twentyFourHour = "24 hour"
    case walkInsOnly = "Walk-ins Only"
    case mobile = "Mobile Service"
    case dropWeight = "Drop Weight"
    case manualCrank = "Manual Crank"
    case electronic = "Electronic"
    case bulkDiscount = "Bulk Discount"
    case freeTrial = "Free Trial"
}
