//
//  friendCountView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/20/25.
//

import SwiftUI
import FirebaseFirestore

struct FriendCountView: View {
    var userID: String
    
    @State private var friendCount: Int = 0
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Friend Count")
                .font(.headline)
            Text("\(friendCount)")
                .font(.title)
                .bold()
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            fetchFriendCount()
        }
    }

    private func fetchFriendCount() {
        let db = Firestore.firestore()

        // Query where user is userID1
        db.collection("friendships")
            .whereField("userID1", isEqualTo: userID)
            .whereField("status", isEqualTo: "accepted")
            .getDocuments { snapshot1, error1 in

                if let error1 = error1 {
                    self.errorMessage = "Error: \(error1.localizedDescription)"
                    return
                }

                let count1 = snapshot1?.documents.count ?? 0

                // Query where user is userID2
                db.collection("friendships")
                    .whereField("userID2", isEqualTo: userID)
                    .whereField("status", isEqualTo: "accepted")
                    .getDocuments { snapshot2, error2 in

                        if let error2 = error2 {
                            self.errorMessage = "Error: \(error2.localizedDescription)"
                            return
                        }

                        let count2 = snapshot2?.documents.count ?? 0

                        // Total accepted friendships
                        self.friendCount = count1 + count2
                    }
            }
    }
}

