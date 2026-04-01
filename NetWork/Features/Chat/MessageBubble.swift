//
//  messageBubble.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/26/25.
//

import SwiftUI

// Reusable view for message bubbles
struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool // for alignment we need to know what text belongs to who

    var body: some View {
        HStack {
            // Basically stating if its the current user, add space
            if isCurrentUser { Spacer() }

            // makes the text in a bubble
            Text(message.text)
                .padding()
                .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isCurrentUser ? .white : .black)
                .cornerRadius(16)
                .frame(maxWidth: 250, alignment: isCurrentUser ? .trailing : .leading)
                .padding(isCurrentUser ? .leading : .trailing, 40)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)

            if !isCurrentUser { Spacer() }
        }
    }
}

