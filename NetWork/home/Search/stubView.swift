//
//  stubView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/22/25.
//

import SwiftUI

// displays the userStub data model with a format
struct StubView: View {
    let user: userStub
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
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
        }
    }
}

#Preview {
    StubView(user: userStub(uid: "123", displayName: "Tezuka Kunimitzu"))
        .padding()
}
