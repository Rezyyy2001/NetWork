//
//  chatService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/28/25.
//

import Foundation
@preconcurrency import FirebaseFirestore

struct ChatService: Sendable {

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
    
    func createConversation(conversationID: String, participants: [String]) async throws {
        do {
            let docRef = db.collection("conversations").document(conversationID)
            try await docRef.setData(["participants": participants], merge: true)
        } catch {
            print("Failed to create conversation: \(error)")
        }
    }
    
    func fetchConversation(for userID: String) async -> [String] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.conversations)
            .whereField("participants", arrayContains: userID)
            .getDocuments()
        else { return [] }
        
        let otherUserIDs = snapshot.documents.compactMap { doc -> String? in
            let data = doc.data()
            let participants = data["participants"] as? [String] ?? []
            return participants.first { $0 != userID }
        }
        return otherUserIDs
    }
}
