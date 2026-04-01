//
//  friendInboxModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/4/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FriendService {
    private let db = Firestore.firestore()
    
    func fetchPendingRequests(for currentUserID: String) async -> [UserStub] {

        guard let snapshot = try? await db.collection("friendships")
            .whereField("userID2", isEqualTo: currentUserID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments()
        else { return [] }
        
        let senderIDs = snapshot.documents.compactMap {
            $0.data()["userID1"] as? String
        }
        
        return await fetchStubs(for: senderIDs)
    }

    private func fetchStubs(for userIDs: [String]) async -> [UserStub] {
        var loadedStubs: [UserStub] = []

        for id in userIDs {
            guard let doc = try? await db.collection("users").document(id).getDocument(), let data = doc.data()
            else { continue }
            
            let stub = UserStub(uid: id, displayName: data["name"] as? String ?? "Unknown")
            loadedStubs.append(stub)
                 
        }
        return loadedStubs
    }
    
    func fetchFriendCount(for userID: String) async throws -> Int {
        //let db = Firestore.firestore()
        
        // Query where user is userID1
        guard let snapshot1 = try? await db.collection("friendships")
            .whereField("userID1", isEqualTo: userID)
            .whereField("status", isEqualTo: "accepted")
            .getDocuments()
        else { return 0 }
        let count1 = snapshot1.documents.count
        
        guard let snapshot2 = try? await db.collection("friendships")
            .whereField("userID2", isEqualTo: userID)
            .whereField("status", isEqualTo: "accepted")
            .getDocuments()
        else { return 0 }
        let count2 = snapshot2.documents.count
        
        return count1 + count2
    }
    
    func checkFriendshipStatus(for targetUserID: String) async throws -> FriendshipStatus {
        //let db = Firestore.firestore()
        
        guard let snapshot1 = try? await db.collection("friendships")
            .whereField("userID1", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField("userID2", isEqualTo: targetUserID)
            .getDocuments()
        else { return .none }
        
        if let doc = snapshot1.documents.first {
            if let status = doc.data()["status"] as? String {
                if status == "pending" {
                    return .sent
                }
                if status == "accepted" {
                    return .friends
                }
            }
        }
        
        guard let snapshot2 = try? await db.collection("friendships")
            .whereField("userID1", isEqualTo: targetUserID)
            .whereField("userID2", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .getDocuments()
        else { return .none }
        
        if let doc = snapshot2.documents.first {
            if let status = doc.data()["status"] as? String {
                if status == "pending" {
                    return .recieved(documentID: doc.documentID)
                }
                if status == "accepted" {
                    return .friends
                }
            }
        }
        return .none
    }
    
    func sendFriendRequest(for targetUserID: String) async throws {
        //let db = Firestore.firestore()
        
        let friendshipData: [String: Any] = [
            "userID1": Auth.auth().currentUser?.uid ?? "", // Current user
            "userID2": targetUserID, // User being viewed
            "status": "pending"
        ]
        
        // creates the document in firestore with the status as pending
        try await db.collection("friendships").addDocument(data: friendshipData)
    }
    
    // Updates the status to accepted if accepted
    func acceptFriendRequest(for documentID: String) async throws {
        //let db = Firestore.firestore()
        try await db.collection("friendships").document(documentID).updateData([
            "status": "accepted"
        ])
    }
    
    // Updates the status to nil if denied
    func denyFriendRequest(for documentID: String) async throws {
        //let db = Firestore.firestore()
        try await db.collection("friendships").document(documentID).delete()
    }
    
    func fetchFriends(for currentUserID: String) async -> [UserStub] {
        
        guard let snapshot = try? await db.collection("friendships")
            .whereField("status", isEqualTo: "accepted")
            .getDocuments()
                
        else { return [] }
        
        let friendIDs = snapshot.documents.compactMap { doc -> String? in
            let data = doc.data()
            let userID1 = data["userID1"] as? String ?? ""
            let userID2 = data["userID2"] as? String ?? ""
        
            // need this because the doc title is the same regardless of who is the current user is
            // lists the friend
            if userID1 == currentUserID { return userID2 }
            else if userID2 == currentUserID { return userID1 }
            return nil
        }
        return await fetchStubs(for: friendIDs)
    }
}
