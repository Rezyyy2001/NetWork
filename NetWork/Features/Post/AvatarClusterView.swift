//
//  AvatarClusterView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/23/26.
//

import SwiftUI

struct AvatarClusterView: View {
    @StateObject private var viewModel: AvatarClusterViewModel
    
    init(postID: String, isOwner: Bool) {
        _viewModel = StateObject(wrappedValue: AvatarClusterViewModel(postID: postID, isOwner: isOwner))
    }
    
    var body: some View {
        HStack(spacing: -20) {
            ForEach(viewModel.profiles, id: \.name) { profile in
                AsyncImage(url: URL(string: profile.profilePictureURL ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person")
                }
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(red: 30/255, green: 143/255, blue: 213/255), lineWidth: 1))
            }
        }
        .task { viewModel.fetchProfiles() }
    }
}
