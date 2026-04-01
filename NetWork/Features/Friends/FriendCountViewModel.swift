//
//  FriendCountViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/12/26.
//

import Foundation

@MainActor
final class FriendCountViewModel: ObservableObject {
    
    @Published var friendCount: Int = 0
    @Published var errorMessage: String?
    
    private let service = FriendService()
    
    var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    func fetchFriendCount(for userID: String) {
        Task {
            do {
                self.friendCount = try await service.fetchFriendCount(for: userID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

