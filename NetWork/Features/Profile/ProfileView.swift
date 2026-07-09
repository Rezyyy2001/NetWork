//
//  profileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var currentUserViewModel = CurrentUserProfileViewModel()
    @StateObject private var userPostsViewModel = UserPostsViewModel(userID: Auth.auth().currentUser?.uid ?? "")
    
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        ScrollView {
            VStack {
                // This is where all the child views will stack up
                HeaderView(viewModel: currentUserViewModel)
                InfoView(viewModel: currentUserViewModel)
                BiographyView(viewModel: currentUserViewModel)
                
                // TODO: add a filter to switch between current and past hit posts
                Picker("Order", selection: $userPostsViewModel.active) {
                    Text("Active").tag(true)
                    Text("Past").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: userPostsViewModel.active) {
                      Task { try? await userPostsViewModel.fetchUserPosts() }
                }
                
                // We need to loop through hitposts to display For each
                ForEach(userPostsViewModel.hits) { post in
                    PostPreviewCard(post: post,
                                    showConfirm: false,
                                    onConfirm: {},
                                    showJoinButton: false,
                                    onJoinRequest: {},
                                    onCancelRequest: {}
                    )
                }
                
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
                        currentUserViewModel.showConfirmedHits = true
                    } label: {
                        Image(systemName: "checkmark.square")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        currentUserViewModel.showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
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
            .sheet(isPresented: $currentUserViewModel.showConfirmedHits) {
                ConfirmedHitsView()
            }
            //This whole block of code is to keep the data updated
            .task {
                await currentUserViewModel.fetchCurrentUserProfile()
                try? await userPostsViewModel.fetchUserPosts()
            }
        }
    }
}

#Preview {
    ProfileView()
}
