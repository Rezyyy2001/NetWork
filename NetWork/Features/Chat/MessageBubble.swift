//
//  messageBubble.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/26/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool // for alignment we need to know what text belongs to who
    let card: BusinessCard?
    let isLiked: Bool
    
    var onLike: (String) -> Void = { _ in }

    //TODO: PUBSUB
    var body: some View {
        HStack {
            // Basically stating if its the current user, add space
            if isCurrentUser { Spacer() }

            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                if let card = card {
                    HStack {
                        BusinessCardView(card: card)
                            .scaledLayout(0.5)
                            .frame(maxWidth: .infinity)
                        Button {
                            onLike(card.id)
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                        .disabled(isLiked)
                    }
                }
                Text(message.text)
                    .padding()
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(16)
                    .padding(.horizontal, 10)
            }
            if !isCurrentUser { Spacer() }
        }
    }
}


