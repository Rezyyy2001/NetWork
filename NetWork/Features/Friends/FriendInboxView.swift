//
//  friendInboxView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/17/25.
//

import SwiftUI

struct FriendInboxView: View {
    @StateObject private var viewModel = FriendInboxViewModel()
    @State private var selectedUser: UserStub?
    
    // TODO: You should not be able to friend yourself
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.stubs.isEmpty {
                    ContentUnavailableView(
                        "No pending requests",
                        systemImage: "tray",
                        description: Text("Friend requests you receive will show up here.")
                    )
                } else {
                    List(viewModel.stubs) { stub in
                        StubView(user: stub) {
                            selectedUser = stub
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationDestination(item: $selectedUser) { user in
                UserProfileView(userID: user.id)
            }
            .onAppear {
                viewModel.fetchPendingRequests()
            }
            .navigationTitle("Friend Requests")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(padded: false)
                }
            }
        }
    }
}
