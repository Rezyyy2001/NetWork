//
//  userProfileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var otherUserProfileViewModel: OtherUserProfileViewModel
    @StateObject private var userPostsViewModel: UserPostsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(userID: String) {
        _otherUserProfileViewModel = StateObject(wrappedValue: OtherUserProfileViewModel(userID: userID))
        _userPostsViewModel = StateObject(wrappedValue: UserPostsViewModel(userID: userID))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HeaderView(viewModel: otherUserProfileViewModel)
                InfoView(viewModel: otherUserProfileViewModel)
                BiographyView(viewModel: otherUserProfileViewModel)
                FriendButtonView(targetUserID: otherUserProfileViewModel.uid)
                
                Picker("Order", selection: $userPostsViewModel.active) {
                    Text("Active").tag(true)
                    Text("Past").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: userPostsViewModel.active) {
                      Task { try? await userPostsViewModel.fetchUserPosts() }
                }
                
                if otherUserProfileViewModel.friendshipStatus == .friends {
                    ForEach(userPostsViewModel.hits) { post in
                        PostPreviewCard(post: post, showConfirm: false, onConfirm: {}, onJoinRequest: {})
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 2)
            .ignoresSafeArea(.container, edges: .horizontal)
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    BackButton(padded: false)
                }
            }
            .navigationBarBackButtonHidden(true)
            .task {
                try? await userPostsViewModel.fetchUserPosts()
            }
        }
    }
}

#Preview {
    UserProfileView(userID: "9qVSt63nrjaqiBm79ZNoOxM7AFd2")
}
