//
//  SearchService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/5/26.
//

import SwiftUI
import Firebase

final class SearchService {
    let db = Firestore.firestore() // references firestore for queries
    
    func searchUsers(matching searchText: String) async -> [UserStub] {
        let searchLowercased = searchText.lowercased()
        
        guard let snapshot = try? await db.collection("users")
            .whereField("name_lowercased", isGreaterThanOrEqualTo: searchLowercased) // looking for users with strings equal or greater than the searchText
            .whereField("name_lowercased", isLessThanOrEqualTo: searchLowercased + "\u{f8ff}") // Ensures partial matches
            .getDocuments()
        else { return [] }
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            let name = data["name"] as? String
            let uid = doc.documentID
            return UserStub(uid: uid, displayName: name)
        }
    }
}
