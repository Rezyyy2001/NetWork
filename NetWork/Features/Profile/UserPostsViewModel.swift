//
//  UserPostsViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/3/26.
//

import Foundation
import Firebase

@MainActor
final class UserPostsViewModel: ObservableObject {
    private let service = PostService()
    
    @Published var hits: [HitPost] = []
    
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
        Task { try? await fetchUserPosts() }
    }
    
    func fetchUserPosts() async throws {
        self.hits = try await service.fetchUserPosts(userID: userID)
    }
}
