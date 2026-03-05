//
//  friendInboxViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/17/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class FriendInboxViewModel: ObservableObject {
    @Published var stubs: [UserStub] = []
    
    private let service = FriendInboxService()
    
    func fetchPendingRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        Task {
            self.stubs = await service.fetchPendingRequests(for: currentUserID)
        }
    }
}
