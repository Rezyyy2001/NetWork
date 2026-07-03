//
//  AvatarClusterViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/23/26.
//

import Foundation

@MainActor
final class AvatarClusterViewModel: ObservableObject {
    private let hitRequestService = HitRequestService()
    
    @Published var profiles: [HitRequestProfile] = []
    var postID: String
    var isOwner: Bool
    
    init(postID: String, isOwner: Bool) {
        self.postID = postID
        self.isOwner = isOwner
    }
    
    func fetchProfiles() {
        Task {
            if isOwner {
                self.profiles = (try? await hitRequestService.fetchRequests(for: postID)) ?? []
            } else {
                self.profiles = await hitRequestService.fetchAcceptedRequest(postID: postID)
            }
        }
    }
    
    func acceptRequests(documentID: String) {
        Task {
            try? await hitRequestService.acceptRequest(documentID: documentID)
        }
    }
}
