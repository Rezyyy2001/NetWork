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
        NavigationStack {
            ScrollView {
                VStack {
                    // This is where all the child views will stack up
                    HeaderView(viewModel: currentUserViewModel)
                    InfoView(viewModel: currentUserViewModel)
                    BiographyView(viewModel: currentUserViewModel)
                    
                    Picker("Order", selection: $userPostsViewModel.active) {
                        Text("Active").tag(true)
                        Text("Past").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: userPostsViewModel.active) {
                        Task { try? await userPostsViewModel.fetchUserPosts() }
                    }
                    
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
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            currentUserViewModel.activeSheet = .messages
                        } label: {
                            Image(systemName: "message")
                                .font(.headline)
                        }
                        Button {
                            currentUserViewModel.activeSheet = .friendRequests
                        } label: {
                            Image(systemName: "tray")
                                .font(.headline)
                        }
                        Button {
                            currentUserViewModel.activeSheet = .confirmedHits
                        } label: {
                            Image(systemName: "checkmark.square")
                                .font(.headline)
                        }
                        Button {
                            currentUserViewModel.activeSheet = .settings
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.headline)
                        }
                    }
                }

                .navigationBarTitleDisplayMode(.inline)

                .sheet(item: $currentUserViewModel.activeSheet, onDismiss: {
                    Task { await currentUserViewModel.fetchCurrentUserProfile() }
                }) { sheet in
                    switch sheet {
                    case .messages:
                        MessageListView(currentUserID: currentUserViewModel.uid)
                    case .friendRequests:
                        FriendInboxView()
                    case .settings:
                        SettingsView(authState: authState)
                    case .confirmedHits:
                        ConfirmedHitsView()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
