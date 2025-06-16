//
//  chatViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/31/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessage = ""

    private let service = ChatService()
    private var listener: ListenerRegistration? // Holds the Firebase listener
    private let conversationID: String
    private let currentUserID: String

    // sets up IDs and listens for emssages from Firestore
    init(currentUserID: String, otherUserID: String) {
        self.currentUserID = currentUserID
        self.conversationID = service.conversationID(for: currentUserID, and: otherUserID) // so that the conversation path is the same no matter the order.
        listenForMessages()
    }

    // do we need this, works as intentded without it
    deinit {
        listener?.remove()
    }

    func sendMessage() {
        let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // builds message object to store in Firestore
        let message = Message(
            id: nil,
            text: trimmed,
            senderID: currentUserID,
            timestamp: Date()
        )

        // once sent, the textField is empty
        service.sendMessage(conversationID: conversationID, message: message) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.newMessage = ""
                }
            }
        }
    }

    //Firestore listens to messages collection and updates the messages array
    private func listenForMessages() {
        listener = service.observeMessages(conversationID: conversationID) { [weak self] messages in
            DispatchQueue.main.async {
                self?.messages = messages
            }
        }
    }
}
