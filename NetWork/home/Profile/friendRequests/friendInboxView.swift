//
//  friendInboxView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/17/25.
//

import SwiftUI

struct friendInboxView: View {
    @StateObject private var viewModel = friendInboxViewModel()
    @State private var selectedUser: userStub?

    var body: some View {
        VStack {
            // Friend Requests List
            List(viewModel.stubs) { stub in
                StubView(user: stub) {
                    selectedUser = stub // Store selected user
                }
                .listRowBackground(Color.clear) // Ensures it doesn’t apply default background
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Friend Requests")
            .onAppear {
                viewModel.fetchPendingRequests() // Fetch data on appear
            }
        }
        .navigationDestination(item: $selectedUser) { user in
            userProfileView(userID: user.id) // Navigate to userProfileView
                .onAppear {
                    print("Navigating to userProfileView for \(user.id)")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}


