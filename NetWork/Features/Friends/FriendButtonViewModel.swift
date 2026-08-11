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
    let currentUserID: String
    private let conversationID: String
    
    init(targetUserID: String) {
        self.targetUserID = targetUserID
        let uid = Auth.auth().currentUser?.uid ?? ""
        self.currentUserID = uid
        self.conversationID = ChatService().conversationID(for: uid, and: targetUserID)
    }
    
    func checkFriendshipStatus(for targetUserID: String) {
        Task {
            do {
                self.friendshipStatus = try await friendService.checkFriendshipStatus(for: targetUserID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func sendFriendRequest(for targetUserID: String) {
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
                
                try await chatService.createConversation(conversationID: conversationID, participants: [currentUserID, targetUserID])
            } catch {
                self.errorMessage = error.localizedDescription
            }
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
