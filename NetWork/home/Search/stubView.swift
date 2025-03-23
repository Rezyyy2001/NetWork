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
    }
}

#Preview {
    StubView(user: userStub(uid: "123", displayName: "Tezuka Kunimitzu"))
        .padding()
}
