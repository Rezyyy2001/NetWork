//
//  ConfirmedHitsViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/4/26.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class ConfirmedHitsViewModel: ObservableObject {
    private let service = HitRequestService()
    @Published var acceptedHitPosts: [HitPost] = []
    
    func fetchConfirmedHits() {
        Task {
            self.acceptedHitPosts = (try? await service.confirmedHits(for: Auth.auth().currentUser?.uid ?? "")) ?? []
        }
    }
}
