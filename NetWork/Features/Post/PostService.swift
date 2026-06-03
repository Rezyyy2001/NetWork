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
    
    func fetchPosts() async throws -> [HitPost] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.posts)
            .getDocuments()
                else { return [] }
        
        return snapshot.documents.compactMap { doc in
            let userID = doc.data()[FirestoreKeys.PostFields.userID] as? String ?? ""
            let posterName = doc.data()[FirestoreKeys.PostFields.posterName] as? String ?? ""
            let posterUTR = doc.data()[FirestoreKeys.PostFields.posterUTR] as? Double
            let posterUSTA = doc.data()[FirestoreKeys.PostFields.posterUSTA] as? Double
            let location = doc.data()[FirestoreKeys.PostFields.location] as? String ?? ""
            let city = doc.data()[FirestoreKeys.PostFields.city] as? String ?? ""
            let timestamp = doc.data()[FirestoreKeys.PostFields.date] as? Timestamp
            let date = timestamp?.dateValue() ?? Date()
            let extraInfo = doc.data()[FirestoreKeys.PostFields.extraInfo] as? String ?? ""
            let numberOfPeople = doc.data()[FirestoreKeys.PostFields.numberOfPeople] as? Int ?? 1
            let isPublic = doc.data()[FirestoreKeys.PostFields.isPublic] as? Bool ?? true
            
            return HitPost(id: doc.documentID, userID: userID, posterName: posterName, posterUTR: posterUTR, posterUSTA: posterUSTA, location: location, city: city, date: date, extraInfo: extraInfo, numberOfPeople: numberOfPeople, isPublic: isPublic)
        }
    }
}
