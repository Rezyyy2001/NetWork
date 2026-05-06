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
            VStack(alignment: .leading) {
                BackButton()
                
                Text("Friend Requests")
                    .font(.largeTitle)
                    .padding(.horizontal)
                
                List(viewModel.stubs) { stub in
                    StubView(user: stub) {
                        selectedUser = stub
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                Spacer()
            }
            .navigationDestination(item: $selectedUser) { user in
                UserProfileView(userID: user.id)
            }
            .onAppear {
                viewModel.fetchPendingRequests()
            }
        }
    }
}
