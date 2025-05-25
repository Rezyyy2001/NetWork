//
//  messageViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/10/25.
//

import FirebaseFirestore
import Foundation
import SwiftUI

class messageListViewModel: ObservableObject {
    @Published var friends: [userStub] = []
    private let db = Firestore.firestore()

    func fetchFriends(for currentUserID: String) {
        db.collection("friendships")
            .whereField("status", isEqualTo: "accepted")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }

                var friendIDs: [String] = []

                for doc in documents {
                    let data = doc.data()
                    let userID1 = data["userID1"] as? String ?? ""
                    let userID2 = data["userID2"] as? String ?? ""

                    if userID1 == currentUserID {
                        friendIDs.append(userID2)
                    } else if userID2 == currentUserID {
                        friendIDs.append(userID1)
                    }
                }

                self.fetchUserStubs(from: friendIDs)
            }
    }

    private func fetchUserStubs(from ids: [String]) {
        guard !ids.isEmpty else { return }

        let group = DispatchGroup()
        var stubs: [userStub] = []

        for id in ids {
            group.enter()
            db.collection("users").document(id).getDocument { snapshot, error in
                defer { group.leave() }

                if let doc = snapshot, doc.exists {
                    let data = doc.data()
                    let displayName = data?["name"] as? String
                    let stub = userStub(uid: id, displayName: displayName)
                    stubs.append(stub)
                }
            }
        }

        group.notify(queue: .main) {
            self.friends = stubs
        }
    }
}

