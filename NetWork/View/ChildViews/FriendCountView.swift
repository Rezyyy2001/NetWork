//
//  FriendCountView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/20/25.
//

import SwiftUI

struct FriendCountView: View {
    @StateObject private var viewModel: FriendCountViewModel
    
    init(userID: String) {
        _viewModel = StateObject(wrappedValue: FriendCountViewModel(userID: userID))
    }
    
    var body: some View {
        VStack {
            Text("Friend Count")
                .font(.headline)
            Text("\(viewModel.friendCount)")
                .font(.title)
                .bold()
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            viewModel.fetchFriendCount(for: viewModel.userID)
        }
    }
}

