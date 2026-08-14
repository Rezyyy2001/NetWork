//
//  chatViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/31/25.
//

import Foundation
@preconcurrency import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessage = ""
    @Published var attachedCard: BusinessCard?

    private let service = ChatService()
    private var listener: ListenerRegistration? // Holds the Firebase listener
    private let conversationID: String
    private let currentUserID: String
    private let otherUserID: String
    private var businessCardID: String?

    init(currentUserID: String, otherUserID: String, businessCardID: String? = nil) {
        self.currentUserID = currentUserID
        self.otherUserID = otherUserID
        self.businessCardID = businessCardID
        self.conversationID = service.conversationID(for: currentUserID, and: otherUserID) // so that the conversation path is the same no matter the order.
        listenForMessages()
        
        print("businessCardID in init: \(String(describing: businessCardID))")
        if let cardID = businessCardID {
            Task {
                attachedCard = try? await BusinessCardService().fetchSingleCard(cardID: cardID)
            }
        }
    }
    
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
            timestamp: Date(),
            businessCardID: businessCardID
        )
        businessCardID = nil

        // once sent, the textField is empty
        Task {
            try? await service.sendMessage(conversationID: conversationID, participants: [currentUserID, otherUserID], message: message)
            newMessage = ""
        }
    }

    //Firestore listens to messages collection and updates the messages array
    private func listenForMessages() {
        listener = service.observeMessages(conversationID: conversationID) { [weak self] messages in
            self?.messages = messages
        }
    }
}
