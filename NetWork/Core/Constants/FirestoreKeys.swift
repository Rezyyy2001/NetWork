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
    }
    enum FriendshipFields {
        static let userID1 = "userID1"
        static let userID2 = "userID2"
        static let status = "status"
    }
}
