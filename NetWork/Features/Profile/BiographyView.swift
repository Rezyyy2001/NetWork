//
//  biographyView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/5/25.
//

import SwiftUI

struct BiographyView<T: UserProfileDataProvider & ObservableObject>: View {
    @ObservedObject var viewModel: T
    

    var body: some View {
        VStack {
            //
            Group {
                if let bio = viewModel.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("No bio yet")
                        .font(.system(size: 15))
                        .italic()
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}
