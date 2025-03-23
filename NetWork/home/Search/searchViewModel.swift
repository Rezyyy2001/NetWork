//
//  searchViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/21/25.
//

import SwiftUI
import FirebaseFirestore

class searchViewModel: ObservableObject {
    
    @Published var searchText: String = "" // The string that is entered in the search bar
    @Published var searchResults: [userStub] = [] // spits back an array of userStubs matching the searchText string

    // searches users in firestore database
    func searchUsers() {
        
        let db = Firestore.firestore() // references firestore for queries
        
        db.collection("users") // looks into the collection users
        
            .whereField("name", isGreaterThanOrEqualTo: searchText) // looking for users with strings equal or greater than the searchText
            .whereField("name", isLessThanOrEqualTo: searchText + "\u{f8ff}") // Ensures partial matches
            .getDocuments { snapshot, error in // gets the doc
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                
                // converts the data in the snapshot into userStubs
                self.searchResults = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    let name = data["name"] as? String
                    let uid = doc.documentID
                    return userStub(uid: uid, displayName: name)
                } ?? [] // if snapshot is empty return empty array
            }
    }
}
