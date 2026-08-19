//
//  chatView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/25/25.
//

import SwiftUI

struct ChatView: View {
    let currentUserID: String
    let otherUser: UserStub

    @StateObject private var viewModel: ChatViewModel // keeps the VM alive across renders

    init(currentUserID: String, otherUser: UserStub, businessCardID: String? = nil) {
        self.currentUserID = currentUserID
        self.otherUser = otherUser
        _viewModel = StateObject(wrappedValue: ChatViewModel(currentUserID: currentUserID, otherUserID: otherUser.id, businessCardID: businessCardID))
    }
    
    private var titleText: String { otherUser.displayName ?? "Chat" }
    
    private var isSendDisabled: Bool {
        viewModel.newMessage.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private struct MessageRow: View {
        let item: MessageWithCard
        let currentUserID: String
        @ObservedObject var viewModel: ChatViewModel

        var body: some View {
            MessageBubble(
                message: item.message,
                isCurrentUser: item.message.senderID == currentUserID,
                card: item.card,
                isLiked: item.isLiked,
                onLike: { cardID in viewModel.likeCard(cardID) }
            )
        }
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in // Scrolls to the latest message
                ScrollView {
                    VStack {
                        ForEach(viewModel.messages) { item in
                            MessageRow(
                                item: item,
                                currentUserID: currentUserID,
                                viewModel: viewModel
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
                    .disabled(isSendDisabled)
                }
                .padding()
            }
        }
        .navigationTitle(titleText)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                BackButton(padded: false)
            }
        }
    }
}
