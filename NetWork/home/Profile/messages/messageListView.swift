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
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MessageListViewModel() // watches for updates
    @State private var selectedUser: UserStub? // to check who is clicked

    init(currentUserID: String) {
            self.currentUserID = currentUserID
            _viewModel = StateObject(wrappedValue: MessageListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.leading)
                        .padding(.top)
                }
                
                Text("Messages")
                    .font(.largeTitle)
                    .padding(.horizontal)

                // shows each friend as a list
                List(viewModel.friends) { friend in
                    StubView(user: friend) {
                        selectedUser = friend // selectedUser triggers navigation
                    }
                }
                .listStyle(PlainListStyle())
            }
            // navigates to chatView when user is selected
            .navigationDestination(item: $selectedUser) { user in
                ChatView(currentUserID: currentUserID, otherUser: user)
            }
            .onAppear {
                viewModel.fetchFriends(for: currentUserID)
            }
        }
    }
}



