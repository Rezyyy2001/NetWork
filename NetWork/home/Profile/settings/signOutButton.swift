//
//  signOutButton.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/8/25.
//

import SwiftUI

struct SignOutButton: View {
    var signOutAction: () -> Void

    var body: some View {
        Section {
            Button(role: .destructive) {
                signOutAction()
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .foregroundColor(.red)
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
