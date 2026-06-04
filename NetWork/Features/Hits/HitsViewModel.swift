//
//  HitsViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/1/26.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class HitsViewModel: ObservableObject {
    private let service = PostService()
    
    @Published var hits: [HitPost] = []
    
    func fetchPosts() {
        Task {
            self.hits = try await service.fetchPosts()
        }
    }
}
