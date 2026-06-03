//
//  profileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var currentUserViewModel = CurrentUserProfileViewModel() //observes CurrentUserProfileViewModel
    // @StateObject private var postViewModel =
    
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        
        VStack {
            // This is where all the child views will stack up
            HeaderView(viewModel: currentUserViewModel)
            InfoView(viewModel: currentUserViewModel)
            BiographyView(viewModel: currentUserViewModel)
            
            
            Spacer()
            
        }
        .padding(.horizontal, 2)
        .ignoresSafeArea(.container, edges: .horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    currentUserViewModel.showMessageView = true
                } label: {
                    Image(systemName: "message")
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    currentUserViewModel.showFriendRequests = true
                } label: {
                    Image(systemName: "tray")
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    currentUserViewModel.showSettings = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.headline)
                }
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $currentUserViewModel.showMessageView) {
            MessageListView(currentUserID: currentUserViewModel.uid)
        }
        .sheet(isPresented: $currentUserViewModel.showFriendRequests) {
            FriendInboxView()
        }
        .sheet(isPresented: $currentUserViewModel.showSettings) {
            SettingsView(authState: authState)
        }
        //This whole block of code is to keep the data updated
        .task {
            await currentUserViewModel.fetchCurrentUserProfile()
        }
    }
}

#Preview {
    ProfileView()
}
