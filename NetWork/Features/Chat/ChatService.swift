//
//  chatService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/28/25.
//

import Foundation
import FirebaseFirestore

struct ChatService {

    private let db = Firestore.firestore()

    func conversationID(for user1: String, and user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_")
    }

    func sendMessage(conversationID: String, message: Message, completion: ((Error?) -> Void)? = nil) {
        do {
            let docRef = db.collection(FirestoreKeys.Collections.conversations)
                .document(conversationID)
                .collection(FirestoreKeys.Collections.messages)
                .document()

            try docRef.setData(from: message, merge: true, completion: completion)
        } catch {
            completion?(error)
        }
    }

    func observeMessages(conversationID: String, onUpdate: @escaping ([Message]) -> Void) -> ListenerRegistration {
        return db.collection(FirestoreKeys.Collections.conversations)
            .document(conversationID)
            .collection(FirestoreKeys.Collections.messages)
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
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
