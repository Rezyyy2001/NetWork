//
//  FriendButtonViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/16/26.
//

import Foundation
import FirebaseAuth

@MainActor
final class FriendButtonViewModel: ObservableObject {
    
    @Published var friendshipStatus: FriendshipStatus = .none
    @Published var errorMessage: String?
    
    private let friendService = FriendService()
    private let chatService = ChatService()
    
    let targetUserID: String
    private let currentUserID: String

    private var conversationID: String {
        chatService.conversationID(for: currentUserID, and: targetUserID)
    }

    init(targetUserID: String) {
        self.targetUserID = targetUserID
        self.currentUserID = Auth.auth().currentUser?.uid ?? ""
    }
    
    func checkFriendshipStatus() {
        Task {
            do {
                self.friendshipStatus = try await friendService.checkFriendshipStatus(for: targetUserID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func sendFriendRequest() {
        Task {
            do {
                try await friendService.sendFriendRequest(for: targetUserID)
                friendshipStatus = .sent
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func acceptFriendRequest(for documentID: String) {
        Task {
            do {
                try await friendService.acceptFriendRequest(for: documentID)
                friendshipStatus = .friends
            } catch {
                self.errorMessage = error.localizedDescription
                return
            }
            try? await chatService.createConversation(conversationID: conversationID, participants: [currentUserID, targetUserID])
        }
    }
    
    func denyFriendRequest(for documentID: String) {
        Task {
            do {
                try await friendService.denyFriendRequest(for: documentID)
                friendshipStatus = .none
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
