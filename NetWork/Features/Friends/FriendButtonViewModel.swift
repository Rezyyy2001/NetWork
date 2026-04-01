//
//  FriendButtonViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/16/26.
//

import Foundation

@MainActor
final class FriendButtonViewModel: ObservableObject {
    
    @Published var friendshipStatus: FriendshipStatus = .none
    @Published var errorMessage: String?
    
    

    private let service = FriendService()
    
    func checkFriendshipStatus(for targetUserID: String) {
        Task {
            do {
                self.friendshipStatus = try await service.checkFriendshipStatus(for: targetUserID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func sendFriendRequest(for targetUserID: String) {
        Task {
            do {
                try await service.sendFriendRequest(for: targetUserID)
                friendshipStatus = .sent
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func acceptFriendRequest(for documentID: String) {
        Task {
            do {
                try await service.acceptFriendRequest(for: documentID)
                friendshipStatus = .friends
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func denyFriendRequest(for documentID: String) {
        Task {
            do {
                try await service.denyFriendRequest(for: documentID)
                friendshipStatus = .none
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
