//
//  chatService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/28/25.
//

import Foundation
import FirebaseFirestore

struct ChatService { // handles chat related firestore operations
    
    private let db = Firestore.firestore() // links to firebase, allows you to query collections and documents

    // creates the conversation ID
    func conversationID(for user1: String, and user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_") // sorted so that the order doesnt matter
    }

    // creates the document for each message sent
    func sendMessage(conversationID: String, message: Message, completion: ((Error?) -> Void)? = nil) {
        do {
            let docRef = db.collection("conversations")
                .document(conversationID)
                .collection("messages")
                .document()

            try docRef.setData(from: message, merge: true, completion: completion)
        } catch {
            completion?(error)
        }
    }

    // This sets up real-time listener for the given conversation
    func observeMessages(conversationID: String, onUpdate: @escaping ([Message]) -> Void) -> ListenerRegistration {
        return db.collection("conversations")
            .document(conversationID)
            .collection("messages")
            .order(by: "timestamp") // key to make it chronological order
            .addSnapshotListener { snapshot, error in // listens for live updates
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let messages: [Message] = documents.compactMap {
                    try? $0.data(as: Message.self)
                }

                onUpdate(messages)
            }
    }
}

