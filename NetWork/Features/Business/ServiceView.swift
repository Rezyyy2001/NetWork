//
//  ServiceView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
import FirebaseAuth

struct ServiceView: View {
    @StateObject private var viewModel = ServiceViewModel()
    @State private var userStub: UserStub?
    @State private var selectedCardID: String?

    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.phase {
                case .loading:
                    ProgressView()

                case .deck, .reviewing:
                    CardStackView(
                        cards: viewModel.cards,
                        onSwipeLeft: { card in
                            userStub = UserStub(uid: card.userID,
                                                displayName: card.cardName,
                                                profilePictureURL: card.profilePicture)
                            selectedCardID = card.id
                            viewModel.handleSwipe(card, .left)
                        },
                        onSwipeRight: { card in
                            viewModel.handleSwipe(card, .right)
                        }
                    )

                case .exhaustedWithSkipped:
                    DeckMessageView(
                        message: "You've gone through every card. Want to revisit the ones you skipped?",
                        buttonTitle: "Review skipped",
                        action: { Task { await viewModel.reviewSkipped() } }
                    )

                case .exhaustedEmpty, .reviewExhausted:
                    DeckMessageView(
                        message: "You've gone through every card. Check back later for new ones.",
                        buttonTitle: "Refresh",
                        action: { Task { await viewModel.refresh() } }
                    )
                }
            }
            .task { await viewModel.start() }
            .navigationDestination(item: $userStub) { user in
                ChatView(currentUserID: currentUserID, otherUser: user, businessCardID: selectedCardID)
                    .toolbar(.hidden, for: .tabBar)
            }
            .onChange(of: userStub) { _, newValue in
                if newValue == nil {
                    selectedCardID = nil
                }
            }
        }
    }
}

private struct DeckMessageView: View {
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button(buttonTitle, action: action)
                .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }
}

#Preview {
    ServiceView()
}
