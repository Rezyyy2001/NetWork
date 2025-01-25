//
//  AuthenticationManager.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let displayName: String?
    let uid: String
    let email: String?
    //let photoUrl: String?
    
    init(user: User) {
        self.displayName = user.displayName
        self.uid = user.uid
        self.email = user.email
        //self.photoUrl = user.photoURL?.absoluteString
    }
}


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func signUp(name: String, email: String, password: String, birthday: Date?) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authDataResult.user
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()

        
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "uid": user.uid,
            "birthday": birthday.map { Timestamp(date: $0) } ?? NSNull() // Convert Date to Timestamp
        ]
        try await Firestore.firestore().collection("users").document(user.uid).setData(userData)
        
        return AuthDataResultModel(user: user)
    }
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    func signOut() throws {
        try Auth.auth().signOut()
    }
    func getAuthenticatedUser() async throws -> AuthDataResultModel? {
        return Auth.auth().currentUser.map { AuthDataResultModel(user: $0) }
    }
}
