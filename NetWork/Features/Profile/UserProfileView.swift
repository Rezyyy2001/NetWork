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
        VStack {
            HeaderView(viewModel: otherUserProfileViewModel)
            InfoView(viewModel: otherUserProfileViewModel)
            BiographyView(viewModel: otherUserProfileViewModel)
            FriendButtonView(targetUserID: otherUserProfileViewModel.uid)
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
    }
}

#Preview {
    UserProfileView(userID: "9qVSt63nrjaqiBm79ZNoOxM7AFd2")
}
