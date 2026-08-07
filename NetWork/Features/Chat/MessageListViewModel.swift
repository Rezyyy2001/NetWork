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
            let friends = await friendService.fetchFriends(for: currentUserID)
            let conversationIDs = await chatService.fetchConversation(for: currentUserID)
            let conversationUsers = await friendService.fetchStubs(for: conversationIDs)
            let combined = friends + conversationUsers.filter { user in
                !friends.contains(where: { $0.id == user.id })
            }
            self.friends = combined
        }
    }
}
