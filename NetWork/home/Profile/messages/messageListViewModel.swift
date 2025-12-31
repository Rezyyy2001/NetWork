//
//  messageViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/10/25.
//

import FirebaseFirestore
import Foundation
import SwiftUI

@MainActor
final class MessageListViewModel: ObservableObject { // Allows the class to notify views when it changes
    @Published var friends: [UserStub] = []
    private let db = Firestore.firestore()

    // finds the current user's friends
    func fetchFriends(for currentUserID: String) {
        // filters through friendships that are accepted
        db.collection("friendships") // Queires friendship collection
            .whereField("status", isEqualTo: "accepted")
        
            .getDocuments { snapshot, error in
            //.getDocuments { [weak self] snapshot, error in
            
                guard let documents = snapshot?.documents, error == nil else { return } // error handles documents

                var friendIDs: [String] = []

                // loops through friendships doc to find other user
                for doc in documents {
                    let data = doc.data()
                    let userID1 = data["userID1"] as? String ?? ""
                    let userID2 = data["userID2"] as? String ?? ""

                    // check if current user is part of friendship then adds the other user
                    if userID1 == currentUserID {
                        friendIDs.append(userID2)
                    } else if userID2 == currentUserID {
                        friendIDs.append(userID1)
                    }
                }

                // feeds friendID to fetchUserStub
                Task { @MainActor in
                    self.fetchUserStubs(from: friendIDs)
                }
            }
    }

    // gets display info for users with given IDs
    private func fetchUserStubs(from ids: [String]) {
        guard !ids.isEmpty else { return } // error handling no id

        let group = DispatchGroup() // used to wait for all async fetches to finish
        var stubs: [UserStub] = [] // list of userStubs

        for id in ids {
            group.enter() // Starts tracking a new async task
            
            // gets docuement from firestore
            db.collection("users").document(id).getDocument { snapshot, error in
                defer { group.leave() } // finishes task and exits

                // creates the userStub and adds it to the list
                if let doc = snapshot, doc.exists {
                    let data = doc.data()
                    let displayName = data?["name"] as? String
                    let stub = UserStub(uid: id, displayName: displayName)
                    stubs.append(stub)
                }
            }
        }

        // displays the userStubs in an array on main thread
        group.notify(queue: .main) {
            self.friends = stubs
        }
    }
}

/// This shouldnt be a retain cycle because the self does not own the closure. Firebase owns the closure and once it gets to the document it deallocates successfully.
/// The dispatch group is necssary because we are doing multiple async calls to each friend ID and the view updates when it all is finished.
/// group.enter and group.leave basically tells you when the async starts and finishes then tells the view to update.
