//
//  AuthenticationManager.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/27/24.
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


final class AuthenticationManager { // for firebase authentication logic
    
    static let shared = AuthenticationManager() // ensures only one instance is used
    private init() {} // prevents other parts of the app from creating an instance ... saves memory
    
    func signUp(name: String, email: String, password: String, birthday: Date?, usualSpot: String) async throws -> AuthDataResultModel { // creates a new profile in firebase
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password) // calls firebases function createUser
        let user = authDataResult.user
        
        let changeRequest = user.createProfileChangeRequest() // change name
        changeRequest.displayName = name
        try await changeRequest.commitChanges() // saves changes

        
        let userData: [String: Any] = [ // dictionary of user details
            "name": name,
            "name_lowercased": name.lowercased(),
            "email": email,
            "uid": user.uid,
            "birthday": birthday.map { Timestamp(date: $0) } ?? NSNull(), // birthday field as a timestamp
            "UTR": 0.0,
            "USTA": 0.0,
            "bio": "",
            "usualSpot": usualSpot
            
        ]
        try await Firestore.firestore().collection("users").document(user.uid).setData(userData)
        
        return AuthDataResultModel(user: user, usualSpot: usualSpot)
    }
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password) // calls firebase signIn method
        return AuthDataResultModel(user: authDataResult.user) // if authentication is successful, return user details
    }
    func signOut() throws {
        try Auth.auth().signOut() // calls firebase signOut method
    }
    func getAuthenticatedUser() async throws -> AuthDataResultModel? { // function to check if there is a user signed in
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Authentication", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        return AuthDataResultModel(user: user) // to check user first before displaying UI elements
    }
    func updateDisplayName(newName: String) async throws { // ensures there is a user before updating the name
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user", code: 0, userInfo: nil)
        }
        
        let changeRequest = user.createProfileChangeRequest() // updates the users firebase authentication profile name
        changeRequest.displayName = newName
        try await changeRequest.commitChanges()
        
        try await Firestore.firestore() // firestore will also get updated
            .collection("users")
            .document(user.uid)
            .updateData(["name": newName])
    }
    func getUserProfile() async throws -> (AuthDataResultModel, Double?, Double?, String?, String?, Date?) {
        guard let user = Auth.auth().currentUser else { // checks if user is signedIn
            throw NSError(domain: "No authenticated user", code: 0, userInfo: nil)
        }
        let userRef = Firestore.firestore().collection("users").document(user.uid) // fetches the data in users collection
        let document = try await userRef.getDocument() // fetches the document data
        
        let UTR = document.data()?["UTR"] as? Double 
        let USTA = document.data()?["USTA"] as? Double
        let bio = document.data()?["bio"] as? String
        let usualSpot = document.data()?["usualSpot"] as? String
        let birthday = (document.data()?["birthday"] as? Timestamp)?.dateValue() // fetches birthday from firestore
        
        return (AuthDataResultModel(user: user, bio: bio, usualSpot: usualSpot), UTR, USTA, bio, usualSpot, birthday)
    }
}
