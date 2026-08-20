//
//  friendButtonView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/9/25.
//

import SwiftUI

struct FriendButtonView: View {
    
    @StateObject private var viewModel: FriendButtonViewModel
    let targetUserID: String // ID of the person being viewed
    
    init(targetUserID: String) {
        self.targetUserID = targetUserID
        _viewModel = StateObject(wrappedValue: FriendButtonViewModel(targetUserID: targetUserID))
    }
    
    var body: some View {
        VStack {
            if case .received(let documentID) = viewModel.friendshipStatus { // meaning you received the friend request
                //receivedPending is just a prefix
                
                // Show Accept / Deny buttons
                HStack {
                    Button("Accept") {
                        viewModel.acceptFriendRequest(for: documentID)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)

                    Button("Deny") {
                        viewModel.denyFriendRequest(for: documentID)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }
                
            // If no request just shows single button that changes
            } else {
                // Add Friend / Pending / Friends button
                Button(action: {
                    viewModel.sendFriendRequest(for: targetUserID)
                }) {
                    Text(buttonTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(buttonColor)
                        .cornerRadius(10)
                }
                .disabled({
                    switch viewModel.friendshipStatus {
                    case .sent, .friends: return true
                    default: return false
                    }
                }()) // if the status is pending or accepted, cant click it
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            viewModel.checkFriendshipStatus(for: targetUserID)
        }
    }

    // returns the correct button title based on the status
    private var buttonTitle: String {
        switch viewModel.friendshipStatus {
        case .sent: return "Pending"
        case .friends: return "Friends"
        case .received: return "Accept / Deny"
        default: return "Add Friend"
        }
    }

    // returns the correct button color based on status
    private var buttonColor: Color {
        switch viewModel.friendshipStatus {
        case .sent, .friends: return .gray
        default: return .blue
        }
    }
}

