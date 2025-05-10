//
//  friendInboxView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/17/25.
//

import SwiftUI

struct friendInboxView: View {
    @Environment(\.dismiss) private var dismiss // to dismiss the sheet
    @StateObject private var viewModel = friendInboxViewModel()
    @State private var selectedUser: userStub?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Back Button
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.leading)
                        .padding(.top)
                }
                
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
                userProfileView(userID: user.id)
            }
            .onAppear {
                viewModel.fetchPendingRequests()
            }
        }
    }
}
