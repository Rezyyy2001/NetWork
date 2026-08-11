//
//  messageViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/10/25.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class MessageListViewModel: ObservableObject {
    @Published var friends: [UserStub] = []
    
    private let friendService = FriendService()
    private let chatService = ChatService()
    
    func fetchAllContacts(for currentUserID: String) {
        Task {
            let conversationIDs = await chatService.fetchConversation(for: currentUserID)
            let conversationUsers = await friendService.fetchStubs(for: conversationIDs)
            self.friends = conversationUsers
        }
    }
}
