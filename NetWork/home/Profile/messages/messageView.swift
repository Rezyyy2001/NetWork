//
//  messageView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/10/25.
//

import SwiftUI

struct messageListView: View {
    let currentUserID: String
    @StateObject private var viewModel = messageListViewModel()
    @State private var selectedUser: userStub?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Messages")
                    .font(.largeTitle)
                    .padding()

                List(viewModel.friends) { friend in
                    StubView(user: friend) {
                        selectedUser = friend
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
            }
//            .navigationDestination(item: $selectedUser) { user in
//                ChatView(currentUserID: currentUserID, otherUser: user)
//            }
            .onAppear {
                viewModel.fetchFriends(for: currentUserID)
            }
        }
    }
}

