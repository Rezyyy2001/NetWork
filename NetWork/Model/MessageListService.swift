//
//  MessageListService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/5/26.
//

import FirebaseFirestore
import Foundation
import SwiftUI

final class MessageListService {
    
    private let db = Firestore.firestore()
    
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
    
    private func fetchStubs(for ids: [String]) async -> [UserStub] {
        var loadedStubs: [UserStub] = []
        
        for id in ids {
            guard let doc = try? await db.collection("users").document(id).getDocument(), let data = doc.data()
            else { continue }
            
            let stub = UserStub(uid: id, displayName: data["name"] as? String ?? "Unknown")
            loadedStubs.append(stub)
        }
        return loadedStubs
    }
}
