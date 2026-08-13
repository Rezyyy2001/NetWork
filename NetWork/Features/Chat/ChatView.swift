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

    init(currentUserID: String, otherUser: UserStub, businessCardID: String? = nil) {
        self.currentUserID = currentUserID
        self.otherUser = otherUser
        _viewModel = StateObject(wrappedValue: ChatViewModel(currentUserID: currentUserID, otherUserID: otherUser.id, businessCardID: businessCardID))
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in // SCrolls to the latest message
                ScrollView {
                    VStack {
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
                .onChange(of: viewModel.messages) { oldValue, newValue in
                    if let last = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            Divider()
            HStack {
                CustomTextbox(
                    text: $viewModel.newMessage,
                    placeholder: "Message",
                    characterLimit: nil
                )
                Button("Send") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .navigationTitle(otherUser.displayName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                BackButton(padded: false)
            }
        }
    }
}
