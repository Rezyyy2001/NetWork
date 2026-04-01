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
            Image(systemName: "person.circle") // Placeholder for profile pic
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)

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

#Preview {
    StubView(user: UserStub(uid: "123", displayName: "Tezuka Kunimitzu"))
        .padding()
}
