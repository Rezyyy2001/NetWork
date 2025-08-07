//
//  chatView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/25/25.
//

import SwiftUI

// The main view for the chat screen
struct ChatView: View {
    let currentUserID: String
    let otherUser: UserStub

    @StateObject private var viewModel: ChatViewModel // keeps the VM alive across renders

    // Since the @StateObject is created once, this init creates the VM with these parameters
    // able to pass data the the @StateObject exactly once
    init(currentUserID: String, otherUser: UserStub) {
        self.currentUserID = currentUserID
        self.otherUser = otherUser
        _viewModel = StateObject(wrappedValue: ChatViewModel(currentUserID: currentUserID, otherUserID: otherUser.id))
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in // SCrolls to the latest message
                ScrollView {
                    VStack {
                        // loops through each message to check if its the current user for bubbling the text
                        ForEach(viewModel.messages) { message in
                            MessageBubble(
                                message: message,
                                isCurrentUser: message.senderID == currentUserID
                            )
                            .id(message.id)
                        }
                    }
                    .padding()
                }
                // scrolls to newest message when viewModel.messages updates
                .onChange(of: viewModel.messages) { oldValue, newValue in
                    if let last = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()
            
// TODO: we need to make it so that you are able to hit enter and make a new line in the chat box

            // adds input field and binds text to viewModel.newMessage
            HStack {
                TextField("Message...", text: $viewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)

                Button("Send") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .navigationTitle(otherUser.displayName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}
