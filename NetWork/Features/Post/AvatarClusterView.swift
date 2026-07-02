//
//  AvatarClusterView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/23/26.
//

import SwiftUI
import Kingfisher

struct AvatarClusterView: View {
    @StateObject private var viewModel: AvatarClusterViewModel
    
    @State private var showSheet: Bool = false
    var onTap: () -> Void = {}
    
    init(postID: String, isOwner: Bool) {
        _viewModel = StateObject(wrappedValue: AvatarClusterViewModel(postID: postID, isOwner: isOwner))
    }
    
    var body: some View {
        HStack(spacing: -20) {
            ForEach(viewModel.profiles, id: \.documentID) { profile in
                KFImage(URL(string: profile.userProfile.profilePictureURL ?? ""))
                    .placeholder {
                    Image(systemName: "person")
                }
                .resizable()
                .scaledToFill()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.brandBlue, lineWidth: 1))
            }
        }
        .task { viewModel.fetchProfiles() }
        .onTapGesture {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            AvatarClusterSheetView(profiles: viewModel.profiles, isOwner: viewModel.isOwner, onAccept: viewModel.acceptRequests)
                .presentationDetents([.height(CGFloat(viewModel.profiles.count) * 80)])
        }
    }
}
