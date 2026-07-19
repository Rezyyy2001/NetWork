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
            .whereField(FirestoreKeys.HitRequestFields.requesterID, isEqualTo: requesterID)
            .getDocuments(),
            let doc = snapshot.documents.first
            else { return nil }
        return doc.documentID
    }

    func acceptRequest(documentID: String) async throws {
        try await db.collection(FirestoreKeys.Collections.hitrequests).document(documentID).updateData([
            FirestoreKeys.HitRequestFields.status: "accepted"
        ])
    }
    
    func fetchRequests(for postID: String) async throws -> [HitRequestProfile] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.postID, isEqualTo: postID)
            .getDocuments()
        else { return [] }
        
        let requesterID = snapshot.documents.compactMap { doc -> (userID: String, documentID: String, status: String)? in
            guard let requesterID = doc.data()[FirestoreKeys.HitRequestFields.requesterID] as? String,
                  let status = doc.data()[FirestoreKeys.HitRequestFields.status] as? String
            else { return nil }
            return (userID: requesterID, documentID: doc.documentID, status: status)
        }
        return await fetchProfiles(for: requesterID)
    }
    
    private func fetchProfiles(for requests: [(userID: String, documentID: String, status: String)]) async -> [HitRequestProfile] {
        var results: [HitRequestProfile] = []
        
        for request in requests {
            guard let doc = try? await db.collection(FirestoreKeys.Collections.users).document(request.userID).getDocument(),
                  let data = doc.data()
            else { continue }
            
            let timestamp = data[FirestoreKeys.UserFields.birthday] as? Timestamp
            
            let userProfile = UserProfile(
                name: data[FirestoreKeys.UserFields.name] as? String ?? "",
                UTR: data[FirestoreKeys.UserFields.utr] as? Double ?? 0.0,
                USTA: data[FirestoreKeys.UserFields.usta] as? Double ?? 0.0,
                usualSpot: data[FirestoreKeys.UserFields.usualSpot] as? String ?? "",
                bio: data[FirestoreKeys.UserFields.bio] as? String ?? "",
                birthday: timestamp?.dateValue(),
                profilePictureURL: data[FirestoreKeys.UserFields.profilePictureURL] as? String
                )
            results.append(HitRequestProfile(documentID: request.documentID, userProfile: userProfile, status: request.status))
        }
        return results
    }
    
    func confirmedHits(for requesterID: String) async throws -> [ConfirmedHit] {
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
    
    private func fetchConfirmedHits(for postID: [String]) async -> [ConfirmedHit] {
        var hits: [ConfirmedHit] = []
        
        for id in postID {
            guard let doc = try? await db.collection(FirestoreKeys.Collections.posts).document(id).getDocument(),
                  let data = doc.data()
            else { continue }
            
            let timestamp = data[FirestoreKeys.PostFields.date] as? Timestamp
            
            let confirmedHit = ConfirmedHit(
                id: id,
                posterName: data[FirestoreKeys.PostFields.posterName] as? String ?? "",
                posterUTR: data[FirestoreKeys.PostFields.posterUTR] as? Double,
                posterUSTA: data[FirestoreKeys.PostFields.posterUSTA] as? Double,
                location: data[FirestoreKeys.PostFields.location] as? String ?? "",
                date: timestamp?.dateValue() ?? Date(),
                extraInfo: data[FirestoreKeys.PostFields.extraInfo] as? String ?? "",
                numberOfPeople: data[FirestoreKeys.PostFields.numberOfPeople] as? Int ?? 0,
                profilePictureURL: data[FirestoreKeys.PostFields.profilePictureURL] as? String,
                latitude: data[FirestoreKeys.PostFields.latitude] as? Double,
                longitude: data[FirestoreKeys.PostFields.longitude] as? Double
                )
            
            if confirmedHit.date >= Date() {
                hits.append(confirmedHit)
            }
        }
        return hits.sorted { $0.date < $1.date }
    }
    
    func fetchExistingRequests() async -> [String] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.requesterID, isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField(FirestoreKeys.HitRequestFields.status, isEqualTo: "pending")
            .getDocuments()
        else { return [] }
        
        return snapshot.documents.compactMap {
            $0.data()[FirestoreKeys.HitRequestFields.postID] as? String
        }
    }
    
    func fetchAcceptedRequest(postID: String) async -> [HitRequestProfile] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.postID, isEqualTo: postID)
            .whereField(FirestoreKeys.HitRequestFields.status, isEqualTo: "accepted")
            .getDocuments()
        else { return [] }
        
        let requesterID = snapshot.documents.compactMap { doc -> (userID: String, documentID: String, status: String)? in
            guard let requesterID = doc.data()[FirestoreKeys.HitRequestFields.requesterID] as? String,
                  let status = doc.data()[FirestoreKeys.HitRequestFields.status] as? String
            else { return nil }
            return (userID: requesterID, documentID: doc.documentID, status: status)
        }
        return await fetchProfiles(for: requesterID)
    }
    
    func fetchAcceptedRequests() async -> [String] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.hitrequests)
            .whereField(FirestoreKeys.HitRequestFields.requesterID, isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField(FirestoreKeys.HitRequestFields.status, isEqualTo: "accepted")
            .getDocuments()
        else { return [] }
        
        return snapshot.documents.compactMap {
            $0.data()[FirestoreKeys.HitRequestFields.postID] as? String
        }
    }
}
