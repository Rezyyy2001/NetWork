//
//  PostService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/30/26.
//

import Foundation
@preconcurrency
import FirebaseFirestore
import FirebaseAuth

struct PostService: Sendable {
    private let db = Firestore.firestore()
    
    func savePost(post: HitPost) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }
        
        let postData: [String: Any] = [
            FirestoreKeys.PostFields.userID: user.uid,
            FirestoreKeys.PostFields.posterName: post.posterName,
            FirestoreKeys.PostFields.posterUTR: post.posterUTR ?? 0.0,
            FirestoreKeys.PostFields.posterUSTA: post.posterUSTA ?? 0.0,
            FirestoreKeys.PostFields.location: post.location,
            FirestoreKeys.PostFields.city: post.city,
            FirestoreKeys.PostFields.date: post.date,
            FirestoreKeys.PostFields.extraInfo: post.extraInfo,
            FirestoreKeys.PostFields.numberOfPeople: post.numberOfPeople,
            FirestoreKeys.PostFields.isPublic: post.isPublic
        ]
        
        try await Firestore.firestore().collection(FirestoreKeys.Collections.posts).document().setData(postData)
    }
    
    func fetchPosts() async throws {
        return
    }
    
}
