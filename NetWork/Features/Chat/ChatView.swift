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
            ScrollViewReader { proxy in // Scrolls to the latest message
                ScrollView {
                    VStack {
                        ForEach(viewModel.messages, id: \.message.id) { item in
                            let isCurrentUser = item.message.senderID == currentUserID
                            MessageBubble(
                                message: item.message,
                                isCurrentUser: isCurrentUser,
                                card: item.card
                            )
                            .id(item.message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages) { oldValue, newValue in
                    guard let last = newValue.last else { return }
                    withAnimation {
                            proxy.scrollTo(last.message.id, anchor: .bottom)
                    }
                }
            }
            Divider()
            VStack(alignment: .center) {
                //TODO: Dont set the frame
                if let card = viewModel.attachedCard {
                    BusinessCardView(card: card)
                        .scaledLayout(0.3)
                        .background(Color.red.opacity(0.3))
                }
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
