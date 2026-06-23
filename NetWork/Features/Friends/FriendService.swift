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

        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.friendships)
            .whereField(FirestoreKeys.FriendshipFields.userID2, isEqualTo: currentUserID)
            .whereField(FirestoreKeys.FriendshipFields.status, isEqualTo: "pending")
            .getDocuments()
        else { return [] }

        let senderIDs = snapshot.documents.compactMap {
            $0.data()[FirestoreKeys.FriendshipFields.userID1] as? String
        }

        return await fetchStubs(for: senderIDs)
    }

    private func fetchStubs(for userIDs: [String]) async -> [UserStub] {
        var loadedStubs: [UserStub] = []

        for id in userIDs {
            guard let doc = try? await db.collection(FirestoreKeys.Collections.users).document(id).getDocument(),
                  let data = doc.data()
            else { continue }

            let stub = UserStub(uid: id, displayName: data[FirestoreKeys.UserFields.name] as? String ?? "Unknown", profilePictureURL: data[FirestoreKeys.UserFields.profilePictureURL] as? String)
            loadedStubs.append(stub)
        }
        return loadedStubs
    }

    private func friendshipCount(field: String, userID: String) async -> Int {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.friendships)
            .whereField(field, isEqualTo: userID)
            .whereField(FirestoreKeys.FriendshipFields.status, isEqualTo: "accepted")
            .getDocuments()
        else { return 0 }
        return snapshot.documents.count
    }

    func fetchFriendCount(for userID: String) async throws -> Int {
        let count1 = await friendshipCount(field: FirestoreKeys.FriendshipFields.userID1, userID: userID)
        let count2 = await friendshipCount(field: FirestoreKeys.FriendshipFields.userID2, userID: userID)
        return count1 + count2
    }

    private func findFriendship(userID1: String, userID2: String) async -> (status: String, documentID: String)? {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.friendships)
            .whereField(FirestoreKeys.FriendshipFields.userID1, isEqualTo: userID1)
            .whereField(FirestoreKeys.FriendshipFields.userID2, isEqualTo: userID2)
            .getDocuments(),
            let doc = snapshot.documents.first,
            let status = doc.data()[FirestoreKeys.FriendshipFields.status] as? String
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
            FirestoreKeys.FriendshipFields.userID1: Auth.auth().currentUser?.uid ?? "",
            FirestoreKeys.FriendshipFields.userID2: targetUserID,
            FirestoreKeys.FriendshipFields.status: "pending"
        ]

        try await db.collection(FirestoreKeys.Collections.friendships).addDocument(data: friendshipData)
    }

    func acceptFriendRequest(for documentID: String) async throws {
        try await db.collection(FirestoreKeys.Collections.friendships).document(documentID).updateData([
            FirestoreKeys.FriendshipFields.status: "accepted"
        ])
    }

    func denyFriendRequest(for documentID: String) async throws {
        try await db.collection(FirestoreKeys.Collections.friendships).document(documentID).delete()
    }

    func fetchFriends(for currentUserID: String) async -> [UserStub] {

        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.friendships)
            .whereField(FirestoreKeys.FriendshipFields.status, isEqualTo: "accepted")
            .getDocuments()
        else { return [] }

        let friendIDs = snapshot.documents.compactMap { doc -> String? in
            let data = doc.data()
            let userID1 = data[FirestoreKeys.FriendshipFields.userID1] as? String ?? ""
            let userID2 = data[FirestoreKeys.FriendshipFields.userID2] as? String ?? ""

            if userID1 == currentUserID { return userID2 }
            else if userID2 == currentUserID { return userID1 }
            return nil
        }
        return await fetchStubs(for: friendIDs)
    }
    
    public func fetchFriendIDs(for currentUserID: String) async -> [String] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.friendships)
            .whereField(FirestoreKeys.FriendshipFields.status, isEqualTo: "accepted")
            .getDocuments()
        else { return [] }
        
        let friendIDs = snapshot.documents.compactMap { doc -> String? in
            let data = doc.data()
            let userID1 = data[FirestoreKeys.FriendshipFields.userID1] as? String ?? ""
            let userID2 = data[FirestoreKeys.FriendshipFields.userID2] as? String ?? ""

            if userID1 == currentUserID { return userID2 }
            else if userID2 == currentUserID { return userID1 }
            return nil
        }
        return friendIDs
    }
}
