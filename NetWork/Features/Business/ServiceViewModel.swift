//
//  ServiceViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/23/26.
//

import Foundation

@MainActor
final class ServiceViewModel: ObservableObject {
    @Published var cards: [BusinessCard] = []
    @Published var isLoading: Bool = false

    private let service = BusinessCardService()

    func fetchCards() async {
        isLoading = true
        do {
            cards = try await service.fetchAllActiveCards()
        } catch {
            print("ServiceViewModel fetchCards error: \(error)")
        }
        isLoading = false
    }
}
