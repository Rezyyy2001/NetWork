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
    
    var isAcceptingLate: Bool {
        time.isWithin(HitRequestService.lateWarningWindow) && !time.hasPassed
    }
    
    var hitHasPassed: Bool {
        time.hasPassed
    }

    var minutesUntilHit: Int {
        time.minutesFromNow
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
