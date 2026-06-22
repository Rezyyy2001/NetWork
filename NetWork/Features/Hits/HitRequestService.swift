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
    
    func cancelRequest(postID: String) async throws {
        if let cancellation = try await findRequest(postID: postID, requesterID: Auth.auth().currentUser?.uid ?? "") {
            try await db.collection(FirestoreKeys.Collections.hitrequests).document(cancellation).delete()
        }
    }
    
    private func findRequest(postID: String, requesterID: String) async throws -> String? {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.postID, isEqualTo: postID)
            .whereField(FirestoreKeys.HitRequestFields.requesterID, isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .getDocuments(),
            let doc = snapshot.documents.first
            else { return nil }
        return (doc.documentID)
    }

    func acceptRequest(documentID: String) async throws {
        try await db.collection(FirestoreKeys.Collections.hitrequests).document(documentID).updateData([
            FirestoreKeys.HitRequestFields.status: "accepted"
        ])
    }
    
    func fetchRequests(for postID: String) async throws -> [UserProfile] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.postID, isEqualTo: postID)
            .whereField(FirestoreKeys.HitRequestFields.status, isEqualTo: "pending")
            .getDocuments()
        else { return [] }
        
        let requesterID = snapshot.documents.compactMap {
            $0.data()[FirestoreKeys.HitRequestFields.requesterID] as? String
        }
        return await fetchProfiles(for: requesterID)
    }
    
    private func fetchProfiles(for userIDs: [String]) async -> [UserProfile] {
        var userProfile: [UserProfile] = []
        
        
        for id in userIDs {
            guard let doc = try? await db.collection(FirestoreKeys.Collections.users).document(id).getDocument(),
                  let data = doc.data()
            else { continue }
            
            let timestamp = data[FirestoreKeys.UserFields.birthday] as? Timestamp
            
            let profile = UserProfile(
                name: data[FirestoreKeys.UserFields.name] as? String ?? "",
                UTR: data[FirestoreKeys.UserFields.utr] as? Double ?? 0.0,
                USTA: data[FirestoreKeys.UserFields.usta] as? Double ?? 0.0,
                usualSpot: data[FirestoreKeys.UserFields.usualSpot] as? String ?? "",
                bio: data[FirestoreKeys.UserFields.bio] as? String ?? "",
                birthday: timestamp?.dateValue(),
                profilePictureURL: data[FirestoreKeys.UserFields.profilePictureURL] as? String
                )
                userProfile.append(profile)
            
        }
        return userProfile
    }
    
    func confirmedHits(for requesterID: String) async throws -> [HitPost] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.requesterID, isEqualTo: requesterID)
            .whereField(FirestoreKeys.HitRequestFields.status, isEqualTo: "accepted")
            .getDocuments()
        else { return [] }
        
        let postID = snapshot.documents.compactMap {
            $0.data()[FirestoreKeys.HitRequestFields.postID] as? String
        }
        return await fetchConfirmedHits(for: postID)
    }
    
    private func fetchConfirmedHits(for postID: [String]) async -> [HitPost] {
        var posts: [HitPost] = []
        
        for id in postID {
            guard let doc = try? await db.collection(FirestoreKeys.Collections.posts).document(id).getDocument(),
                  let data = doc.data()
            else { continue }
            
            let timestamp = data[FirestoreKeys.PostFields.date] as? Timestamp
            
            let hitPost = HitPost(
                id: id,
                userID: data[FirestoreKeys.PostFields.userID] as? String ?? "",
                posterName: data[FirestoreKeys.PostFields.posterName] as? String ?? "",
                posterUTR: data[FirestoreKeys.PostFields.posterUTR] as? Double ?? 0.0,
                posterUSTA: data[FirestoreKeys.PostFields.posterUSTA] as? Double ?? 0.0,
                location: data[FirestoreKeys.PostFields.location] as? String ?? "",
                city: data[FirestoreKeys.PostFields.city] as? String ?? "",
                date: timestamp?.dateValue() ?? Date(),
                extraInfo: data[FirestoreKeys.PostFields.extraInfo] as? String ?? "",
                numberOfPeople: data[FirestoreKeys.PostFields.numberOfPeople] as? Int ?? 0,
                isPublic: data[FirestoreKeys.PostFields.isPublic] as? Bool ?? true
                )
            
                posts.append(hitPost)
            
        }
        return posts
    }
}
