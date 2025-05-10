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
    let targetUserID: String // ID of the person being viewed
    
    @State private var friendshipStatus: String? = nil
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            
            if let status = friendshipStatus, status.starts(with: "receivedPending:") { // meaning you recieved the friend request
                //receivedPending is just a prefix
                
                // Show Accept / Deny buttons
                HStack {
                    Button("Accept") {
                        let docID = String(status.dropFirst("receivedPending:".count))
                        acceptFriendRequest(documentID: docID)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)

                    Button("Deny") {
                        let docID = String(status.dropFirst("receivedPending:".count))
                        denyFriendRequest(documentID: docID)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }
                
            // If no request just shows single button that changes
            } else {
                // Add Friend / Pending / Friends button
                Button(action: {
                    sendFriendRequest()
                }) {
                    Text(buttonTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(buttonColor)
                        .cornerRadius(10)
                }
                .disabled(friendshipStatus == "pending" || friendshipStatus == "accepted") // if the status is pending or accepted, cant click it
            }

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

    // returns the correct button title based on the status
    private var buttonTitle: String {
        if let status = friendshipStatus {
            if status == "pending" {
                return "Pending"
            } else if status == "accepted" {
                return "Friends"
            } else if status.starts(with: "receivedPending:") {
                return "Accept / Deny"
            }
        }
        return "Add Friend"
    }

    // returns the correct button color based on status
    private var buttonColor: Color {
        switch friendshipStatus {
        case "pending", "accepted":
            return .gray
        default:
            return .blue
        }
    }

    private func sendFriendRequest() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { // Gets current user uid
            errorMessage = "User not logged in"
            return
        }

        let db = Firestore.firestore()
        let friendshipData: [String: Any] = [
            "userID1": currentUserID, // Current user
            "userID2": targetUserID, // User being viewed
            "status": "pending"
        ]
        
        // creates the document in firestore with the status as pending
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

        // checks if the logged in user sent the friend request
        db.collection("friendships")
            .whereField("userID1", isEqualTo: currentUserID)
            .whereField("userID2", isEqualTo: targetUserID)
            .getDocuments { sentSnapshot, error in

                if let error = error {
                    errorMessage = "Error checking sent request: \(error.localizedDescription)"
                    return
                }

                // If we find a document that matches the quiery, we change the status
                if let doc = sentSnapshot?.documents.first {
                    self.friendshipStatus = doc.data()["status"] as? String
                    return
                }

                // checks if the logged in user recieved the friend request
                db.collection("friendships")
                    .whereField("userID1", isEqualTo: targetUserID)
                    .whereField("userID2", isEqualTo: currentUserID)
                    .getDocuments { receivedSnapshot, error in

                        if let error = error {
                            errorMessage = "Error checking received request: \(error.localizedDescription)"
                            return
                        }

                        // If we find a document that matches the quiery, we change the status
                        if let doc = receivedSnapshot?.documents.first {
                            let status = doc.data()["status"] as? String
                            if status == "pending" {
                                self.friendshipStatus = "receivedPending:\(doc.documentID)"
                            } else {
                                self.friendshipStatus = status
                            }
                        } else {
                            self.friendshipStatus = nil // No relationship
                        }
                    }
            }
    }

    // Updates the status to accepted if accepted
    private func acceptFriendRequest(documentID: String) {
        let db = Firestore.firestore()
        db.collection("friendships").document(documentID).updateData([
            "status": "accepted"
        ]) { error in
            if let error = error {
                errorMessage = "Failed to accept: \(error.localizedDescription)"
            } else {
                friendshipStatus = "accepted"
            }
        }
    }

    // Updates the status to nil if denied
    private func denyFriendRequest(documentID: String) {
        let db = Firestore.firestore()
        db.collection("friendships").document(documentID).delete { error in
            if let error = error {
                errorMessage = "Failed to deny: \(error.localizedDescription)"
            } else {
                friendshipStatus = nil
            }
        }
    }
}

