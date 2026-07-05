//
//  messageView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/10/25.
//

import SwiftUI

// A view of a friends list
struct MessageListView: View {
    
    let currentUserID: String

    @StateObject private var viewModel = MessageListViewModel() // watches for updates
    @State private var selectedUser: UserStub? // to check who is clicked

    init(currentUserID: String) {
            self.currentUserID = currentUserID
            _viewModel = StateObject(wrappedValue: MessageListViewModel())
    }
    
    // TODO: The list should be in the order of when the messages come in. So newest message at the top
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.friends.isEmpty {
                    ContentUnavailableView(
                        "No messages yet",
                        systemImage: "message",
                        description: Text("Add friends to start chatting.")
                    )
                } else {
                    List(viewModel.friends) { friend in
                        StubView(user: friend) {
                            selectedUser = friend
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            // navigates to chatView when user is selected
            .navigationDestination(item: $selectedUser) { user in
                ChatView(currentUserID: currentUserID, otherUser: user)
            }
            .onAppear {
                viewModel.fetchFriends(for: currentUserID)
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(padded: false)
                }
            }
        }
    }
}



