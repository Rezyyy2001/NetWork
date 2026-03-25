//
//  AuthenticationManager.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
}
