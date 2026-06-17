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
    private let postService = PostService()
    private let friendService = FriendService()
    private let hitRequestService = HitRequestService()
    
    @Published var hits: [HitPost] = []
    
    @Published var isNewest: Bool = true
    @Published var numberOfPeople: Int = 0
    @Published var isFriends: Bool = false
    @Published var UTR: Int = 0
    @Published var USTA: Int = 0
    
    @Published var showFilter: Bool = false
    
    @Published var utrRange: [CGFloat] = [1, 16]
    @Published var ustaRange: [CGFloat] = [1, 7]
    
    func fetchPosts() {
        Task {
            var friendIDs: [String] = []
            
            if isFriends == true {
                let userID = Auth.auth().currentUser?.uid ?? ""
                friendIDs = await friendService.fetchFriendIDs(for: userID)
                print("friendIDs: \(friendIDs)")
            }
            
            self.hits = (try? await postService.fetchPosts(
                isNewest: isNewest,
                numberOfPeople: numberOfPeople,
                isFriends: isFriends,
                utrRange: utrRange,
                ustaRange: ustaRange,
                friendIDs: friendIDs
            )) ?? []
        }
    }
    
    func sendRequest(for post: HitPost) {
        Task {
            try await hitRequestService.sendRequest(postID: post.id, posterID: post.userID)
        }
    }
    
    func cancelRequest(for post: HitPost) {
        Task {
            try await hitRequestService.cancelRequest(documentID: post.id)
        }
    }
}
