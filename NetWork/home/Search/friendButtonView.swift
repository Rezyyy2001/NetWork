//
//  friendButtonView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/9/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct friendButtonView: View {
    let targetUserID: String
    
    @State private var friendshipStatus: String? = nil // "pending", "accepted", or nil
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Button(action: {
                sendFriendRequest()
            }) {
                Text(buttonTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(buttonColor)
                    .cornerRadius(10)
            }
            .disabled(friendshipStatus == "pending" || friendshipStatus == "accepted")

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            checkFriendshipStatus()
        }
    }

    private var buttonTitle: String {
        switch friendshipStatus {
        case "pending":
            return "Pending"
        case "accepted":
            return "Friends"
        default:
            return "Add Friend"
        }
    }

    private var buttonColor: Color {
        switch friendshipStatus {
        case "pending", "accepted":
            return .gray
        default:
            return .blue
        }
    }

    private func sendFriendRequest() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in"
            return
        }

        let db = Firestore.firestore()
        let friendshipData: [String: Any] = [
            "userID1": currentUserID,
            "userID2": targetUserID,
            "status": "pending"
        ]

        db.collection("friendships").addDocument(data: friendshipData) { error in
            if let error = error {
                errorMessage = "Error sending request: \(error.localizedDescription)"
            } else {
                friendshipStatus = "pending"
            }
        }
    }

    private func checkFriendshipStatus() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in"
            return
        }

        let db = Firestore.firestore()
        db.collection("friendships")
            .whereField("userID1", isEqualTo: currentUserID)
            .whereField("userID2", isEqualTo: targetUserID)
            .getDocuments { snapshot, error in
                if let error = error {
                    errorMessage = "Error checking status: \(error.localizedDescription)"
                    return
                }

                if let documents = snapshot?.documents, let doc = documents.first {
                    self.friendshipStatus = doc.data()["status"] as? String
                }
            }
    }
}
