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
    @Published var messages: [MessageWithCard] = []
    @Published var newMessage = ""
    @Published var attachedCard: BusinessCard?

    private let chatService = ChatService()
    private var listener: ListenerRegistration? // Holds the Firebase listener
    private let conversationID: String
    private let currentUserID: String
    private let otherUserID: String
    private var businessCardID: String?
    
    private let businessCardService = BusinessCardService()

    init(currentUserID: String, otherUserID: String, businessCardID: String? = nil) {
        self.currentUserID = currentUserID
        self.otherUserID = otherUserID
        self.businessCardID = businessCardID
        self.conversationID = chatService.conversationID(for: currentUserID, and: otherUserID) // so that the conversation path is the same no matter the order.
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

        let swipedCardID = businessCardID

        // builds message object to store in Firestore
        let message = Message(
            id: nil,
            text: trimmed,
            senderID: currentUserID,
            timestamp: Date(),
            businessCardID: businessCardID
        )
        attachedCard = nil
        businessCardID = nil

        // once sent, the textField is empty
        Task {
            try? await chatService.sendMessage(conversationID: conversationID, participants: [currentUserID, otherUserID], message: message)
            newMessage = ""
            if let swipedCardID {
                try? await businessCardService.recordSwipe(cardID: swipedCardID, direction: .left)
            }
        }
    }

    //Firestore listens to messages collection and updates the messages array
    private func listenForMessages() {
        listener = chatService.observeMessages(conversationID: conversationID) { [weak self] messages in
            Task { [weak self] in
                guard let self else { return }
                var result: [MessageWithCard] = []
                for message in messages {
                    if let cardID = message.businessCardID {
                        let card = try? await businessCardService.fetchSingleCard(cardID: cardID)
                        let hasLiked = await businessCardService.hasLiked(cardID: cardID)
                        result.append(MessageWithCard(message: message, card: card, isLiked: hasLiked))
                    } else {
                        result.append(MessageWithCard(message: message, card: nil, isLiked: false))
                    }
                }
                self.messages = result
            }
        }
    }
    
    func likeCard(_ cardID: String) {
        Task {
            try await businessCardService.likeCard(cardID: cardID)
            messages = messages.map { item in
                guard item.card?.id == cardID else { return item }
                return MessageWithCard(message: item.message, card: item.card, isLiked: true)
            }
        }
    }
}
