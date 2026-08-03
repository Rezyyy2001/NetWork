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
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    

    var body: some View {
        NavigationStack {
            CardStackView(cards: viewModel.cards, leftSwipe: { stub in
                userStub = stub
            })
            .task { await viewModel.fetchCards() }
            .navigationDestination(item: $userStub) { user in
                ChatView(currentUserID: currentUserID, otherUser: user)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview {
    ServiceView()
}


