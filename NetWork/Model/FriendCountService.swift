//
//  FriendCountService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/12/26.
//

import Foundation
import Firebase

final class FriendCountService {
    
    func fetchFriendCount(for userID: String) async throws -> Int {
        let db = Firestore.firestore()
        
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
}
