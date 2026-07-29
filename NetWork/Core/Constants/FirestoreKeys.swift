//
//  FirestoreKeys.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/5/26.
//

import Foundation

enum FirestoreKeys {
    enum Collections {
        static let users = "users"
        static let friendships = "friendships"
        static let conversations = "conversations"
        static let messages = "messages"
        static let posts = "posts"
        static let hitrequests = "hitrequests"
        static let businessCard = "businessCard"
    }
    enum UserFields {
        static let name = "name"
        static let nameLowercased = "name_lowercased"
        static let lastNameLowercased = "last_name_lowercased"
        static let utr = "UTR"
        static let usta = "USTA"
        static let bio = "bio"
        static let usualSpot = "usualSpot"
        static let email = "email"
        static let uid = "uid"
        static let birthday = "birthday"
        static let profilePictureURL = "profilePictureURL"
    }
    enum FriendshipFields {
        static let userID1 = "userID1"
        static let userID2 = "userID2"
        static let status = "status"
    }
    enum PostFields {
        static let userID = "userID"
        static let posterName = "posterName"
        static let posterUTR = "posterUTR"
        static let posterUSTA = "posterUSTA"
        static let location = "location"
        static let city = "city"
        static let date = "date"
        static let extraInfo = "extraInfo"
        static let numberOfPeople = "numberOfPeople"
        static let isPublic = "isPublic"
        static let profilePictureURL = "profilePictureURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    enum HitRequestFields {
        static let postID = "postID"
        static let requesterID = "requesterID"
        static let posterID = "posterID"
        static let status = "status"
    }
    enum BusinessCardFields {
        static let id =  "id"
        static let userID = "userID"
        static let isActive = "isActive"
        
        static let serviceType = "serviceType"
        static let pricing = "pricing"
    
        static let city = "city"
        static let likeCount = "likeCount"
        
        static let description = "description"
        static let tags = "tags"

        static let phoneNumber = "phoneNumber"
        static let email = "email"
        static let insta = "insta"
        
        static let cardName = "cardName"
        static let profilePicture = "profilePicture"
        static let backgroundPic = "backgroundPic"
    }
}
