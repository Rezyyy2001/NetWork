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

    func sendMessage(conversationID: String, participants: [String], message: Message) async throws {
        try await createConversation(conversationID: conversationID, participants: participants)
        let docRef = db.collection(FirestoreKeys.Collections.conversations)
            .document(conversationID)
            .collection(FirestoreKeys.Collections.messages)
            .document()

        try docRef.setData(from: message, merge: true)
        
        try await db.collection(FirestoreKeys.Collections.conversations)
            .document(conversationID)
            .updateData(["lastMessageTimestamp": Date()])
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
        let docRef = db.collection(FirestoreKeys.Collections.conversations).document(conversationID)
        let exists = (try? await docRef.getDocument())?.exists ?? false

        var data: [String: Any] = ["participants": participants]
        
        if !exists {
            data["lastMessageTimestamp"] = Date()
        }
        try await docRef.setData(data, merge: true)
    }
    
    func fetchConversation(for userID: String) async -> [String] {
        do {
            let snapshot = try await db.collection(FirestoreKeys.Collections.conversations)
                .whereField("participants", arrayContains: userID)
                .getDocuments()
            
            let sorted = snapshot.documents.sorted { a, b in
                let ta = (a.data()["lastMessageTimestamp"] as? Timestamp)?.dateValue() ?? .distantPast
                let tb = (b.data()["lastMessageTimestamp"] as? Timestamp)?.dateValue() ?? .distantPast
                return ta > tb   // newest first; message-less conversations sink to the bottom
            }

            let otherUserIDs = sorted.compactMap { doc -> String? in
                let participants = doc.data()["participants"] as? [String] ?? []
                return participants.first { $0 != userID }
            }
            return otherUserIDs
        } catch {
            print("fetchConversation failed \(error)")
            return []
        }
    }
}
