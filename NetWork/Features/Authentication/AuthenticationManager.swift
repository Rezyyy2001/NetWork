//
//  AuthenticationManager.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthenticationManager: Sendable { // for firebase authentication logic
    
    static let shared = AuthenticationManager() // ensures only one instance is used
    private init() {} // prevents other parts of the app from creating an instance ... saves memory
    
    func signUp(name: String, email: String, password: String, birthday: Date?, usualSpot: String) async throws { // creates a new profile in firebase
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password) // calls firebases function createUser
        let user = authDataResult.user
        
        let changeRequest = user.createProfileChangeRequest() // change name
        changeRequest.displayName = name
        try await changeRequest.commitChanges() // saves changes
    }
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password) // calls firebase signIn method
    }
    func signOut() throws {
        try Auth.auth().signOut() // calls firebase signOut method
    }
}
