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
    
    @Published var isNewest: Bool = false
    @Published var numberOfPeople: Int = 0
    @Published var isFriends: Bool = false
    
    @Published var showFilter: Bool = false
    
    func fetchPosts() {
        Task {
            self.hits = try await service.fetchPosts()
        }
    }
}
