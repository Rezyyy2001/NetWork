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
            CardStackView(cards: viewModel.cards, leftSwipe: { stub, cardID in
                userStub = stub
                selectedCardID = cardID
            })
            .task { await viewModel.fetchCards() }
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

#Preview {
    ServiceView()
}


