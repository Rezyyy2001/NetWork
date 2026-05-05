//
//  friendInboxModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/4/26.
//

import Foundation
@preconcurrency import FirebaseFirestore
import FirebaseAuth

final class FriendService: Sendable {
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
    
    private func friendshipCount(field: String, userID: String) async -> Int {
        guard let snapshot = try? await db.collection("friendships")
            .whereField(field, isEqualTo: userID)
            .whereField("status", isEqualTo: "accepted")
            .getDocuments()
        else { return 0 }
        return snapshot.documents.count
    }

    func fetchFriendCount(for userID: String) async throws -> Int {
        let count1 = await friendshipCount(field: "userID1", userID: userID)
        let count2 = await friendshipCount(field: "userID2", userID: userID)
        return count1 + count2
    }
    
    private func findFriendship(userID1: String, userID2: String) async -> (status: String, documentID: String)? {
        guard let snapshot = try? await db.collection("friendships")
            .whereField("userID1", isEqualTo: userID1)
            .whereField("userID2", isEqualTo: userID2)
            .getDocuments(),
            let doc = snapshot.documents.first,
            let status = doc.data()["status"] as? String
        else { return nil }
        return (status: status, documentID: doc.documentID)
    }

    func checkFriendshipStatus(for targetUserID: String) async throws -> FriendshipStatus {
        let currentUserID = Auth.auth().currentUser?.uid ?? ""

        if let result = await findFriendship(userID1: currentUserID, userID2: targetUserID) {
            if result.status == "pending" { return .sent }
            if result.status == "accepted" { return .friends }
        }

        if let result = await findFriendship(userID1: targetUserID, userID2: currentUserID) {
            if result.status == "pending" { return .recieved(documentID: result.documentID) }
            if result.status == "accepted" { return .friends }
        }

        return .none
    }
    
    func sendFriendRequest(for targetUserID: String) async throws {
        
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
