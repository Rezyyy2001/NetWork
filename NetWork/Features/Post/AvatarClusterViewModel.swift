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
    var time: Date
    
    init(postID: String, isOwner: Bool, time: Date) {
        self.postID = postID
        self.isOwner = isOwner
        self.time = time
    }
    
    let oneHour: Double = 3600
    
    var isAcceptingLate: Bool {
        let cutoff = time - oneHour
        return Date() > cutoff
    }

    var minutesUntilHit: Int {
        Int(time.timeIntervalSinceNow / 60)
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
