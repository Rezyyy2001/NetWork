//
//  HitRequestService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/14/26.
//

import Foundation
@preconcurrency
import FirebaseFirestore
import FirebaseAuth

struct HitRequestService: Sendable {
    private let db = Firestore.firestore()
    
    func sendRequest(postID: String, posterID: String) async throws {
        let hitRequestData: [String: Any] = [
            FirestoreKeys.HitRequestFields.postID: postID,
            FirestoreKeys.HitRequestFields.requesterID: Auth.auth().currentUser?.uid ?? "",
            FirestoreKeys.HitRequestFields.posterID: posterID,
            FirestoreKeys.HitRequestFields.status: "pending"
        ]
        try await db.collection(FirestoreKeys.Collections.hitrequests).addDocument(data: hitRequestData)
    }
    
    func cancelRequest(documentID: String) async throws {
        try await db.collection(FirestoreKeys.Collections.hitrequests).document(documentID).delete()
    }
    
    func acceptRequest(documentID: String) async throws {
        try await db.collection(FirestoreKeys.Collections.hitrequests).document(documentID).updateData([
            FirestoreKeys.HitRequestFields.status: "accepted"
        ])
    }
    
    func fetchRequests(for postID: String) async throws -> [UserProfile] {
        return []
    }
    func confirmedHits(for userID: String) async throws -> [HitPost] {
        return []
    }
}
