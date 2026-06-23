//
//  stubView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/22/25.
//

import SwiftUI

struct StubView: View {
    let user: UserStub
    var onTap: () -> Void = {}

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profilePictureURL ?? "")) { image in image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "person")
                    .foregroundColor(Color(red: 30/255, green: 143/255, blue: 213/255))
                    .font(.system(size: 25))
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(red: 30/255, green: 143/255, blue: 213/255), lineWidth: 2))

            Text(user.displayName ?? "Unknown User")
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .onTapGesture {
            onTap() // Handle tap for navigation
        }
    }
}
