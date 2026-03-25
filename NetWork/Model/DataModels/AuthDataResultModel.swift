//
//  AuthDataResultModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel { // variables that store user info
    let displayName: String?
    let uid: String
    let email: String?
    let bio: String?
    let usualSpot: String?
    

    init(user: User, bio: String? = nil, usualSpot: String? = nil) { // extracts user info from firebase
        self.displayName = user.displayName
        self.uid = user.uid
        self.email = user.email
        self.bio = bio
        self.usualSpot = usualSpot


        
        //self.photoUrl = user.photoURL?.absoluteString
    }
}
