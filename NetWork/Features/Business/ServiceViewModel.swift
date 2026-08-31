//
//  ServiceViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/23/26.
//

import Foundation

@MainActor
final class ServiceViewModel: ObservableObject {

    enum Phase: Equatable {
        case loading
        case deck                 
        case reviewing
        case exhaustedWithSkipped
        case exhaustedEmpty
        case reviewExhausted
    }

    @Published private(set) var cards: [BusinessCard] = []
    @Published private(set) var phase: Phase = .loading

    private let service = BusinessCardService()

    private var excluded: Set<String> = []
    private var skippedIDs: [String] = []
    private var pool: [BusinessCard] = []
    private var isReviewing = false

    private let batchSize = 10
    private let prefetchThreshold = 2

    func start() async {
        phase = .loading
        cards = []
        pool = []
        excluded = []
        skippedIDs = []
        isReviewing = false

        do {
            let history = try await service.fetchSwipeHistory()
            excluded = history.excluded
            skippedIDs = history.skipped
        } catch {
            print("ServiceViewModel.start swipe-history error: \(error)")
        }

        do {
            let active = try await service.fetchActiveCards()
            pool = active.filter { !excluded.contains($0.id) }.shuffled()
        } catch {
            print("ServiceViewModel.start fetch error: \(error)")
        }

        dealNextBatch()
        updatePhaseAfterDiscovery()
    }

    func refresh() async {
        await start()
    }

    func handleSwipe(_ card: BusinessCard, _ direction: SwipeDirection) {
        cards.removeAll { $0.id == card.id }
        excluded.insert(card.id)

        if !isReviewing, cards.count <= prefetchThreshold {
            dealNextBatch()
        }
        if cards.isEmpty {
            if isReviewing { phase = .reviewExhausted }
            else { updatePhaseAfterDiscovery() }
        }

        if direction == .right {
            Task { [weak self] in
                guard let self else { return }
                do {
                    try await service.recordSwipe(cardID: card.id, direction: .right)
                } catch {
                    print("ServiceViewModel.handleSwipe record error: \(error)")
                }
            }
        }
    }

    func reviewSkipped() async {
        isReviewing = true
        phase = .loading
        do {
            cards = try await service.fetchCards(withIDs: skippedIDs)
        } catch {
            print("ServiceViewModel.reviewSkipped error: \(error)")
            cards = []
        }
        phase = cards.isEmpty ? .reviewExhausted : .reviewing
    }

    private func dealNextBatch() {
        guard !isReviewing, !pool.isEmpty else { return }
        let count = min(batchSize, pool.count)
        cards.insert(contentsOf: pool.prefix(count), at: 0)
        pool.removeFirst(count)
    }

    private func updatePhaseAfterDiscovery() {
        if !cards.isEmpty {
            phase = .deck
        } else if !skippedIDs.isEmpty {
            phase = .exhaustedWithSkipped
        } else {
            phase = .exhaustedEmpty
        }
    }
}
