//
//  friendInboxViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/17/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class friendInboxViewModel: ObservableObject {
    @Published var stubs: [userStub] = []

    private let db = Firestore.firestore()
    
    func fetchPendingRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        db.collection("friendships")
            .whereField("userID2", isEqualTo: currentUserID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friend requests: \(error.localizedDescription)")
                    return
                }

                let senderIDs = snapshot?.documents.compactMap {
                    $0.data()["userID1"] as? String
                } ?? []

                self.fetchStubs(for: senderIDs)
            }
    }

    private func fetchStubs(for userIDs: [String]) {
        var loadedStubs: [userStub] = []
        let group = DispatchGroup()

        for id in userIDs {
            group.enter()
            db.collection("users").document(id).getDocument { docSnapshot, error in
                defer { group.leave() }

                guard let data = docSnapshot?.data() else { return }

                let stub = userStub(
                    uid: id,
                    displayName: data["name"] as? String ?? "Unknown"
                )

                loadedStubs.append(stub)
            }
        }

        group.notify(queue: .main) {
            self.stubs = loadedStubs
        }
    }
}


