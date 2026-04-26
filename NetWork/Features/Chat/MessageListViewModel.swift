//
//  messageViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/10/25.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
final class MessageListViewModel: ObservableObject {
    @Published var friends: [UserStub] = []
    
    private let service = FriendService()
    
    func fetchFriends(for currentUserID: String) {
        Task {
            self.friends = await service.fetchFriends(for: currentUserID)
        }
    }
    
    func myRandomFunc() {
        Task {
            for i in 0...100 {
                try? await Task.sleep(for: .seconds(3))
                print("Test: \(i)")
            }
        }
    }
}
