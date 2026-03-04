//
//  searchViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/21/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = "" // The string that is entered in the search bar
    @Published var searchResults: [UserStub] = [] // spits back an array of userStubs matching the searchText string

    // searches users in firestore database
    func searchUsers() {
        
        let db = Firestore.firestore() // references firestore for queries
        let searchLowercased = searchText.lowercased()
        
        db.collection("users") // looks into the collection users
        
            .whereField("name_lowercased", isGreaterThanOrEqualTo: searchLowercased) // looking for users with strings equal or greater than the searchText
            .whereField("name_lowercased", isLessThanOrEqualTo: searchLowercased + "\u{f8ff}") // Ensures partial matches
            .getDocuments { snapshot, error in // gets the doc
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                
                // converts the data in the snapshot into userStubs
                Task { @MainActor in
                    self.searchResults = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        let name = data["name"] as? String
                        let uid = doc.documentID
                        return UserStub(uid: uid, displayName: name)
                    } ?? [] // if snapshot is empty return empty array
                }
            }
    }
}
