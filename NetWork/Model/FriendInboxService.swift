//
//  friendInboxModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/4/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FriendInboxService {
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
}
