//
//  HitsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
import FirebaseAuth

struct HitsView: View {
    
    @StateObject private var viewModel = HitsViewModel()
    @State private var lateRequestWarning: Bool = false
    @State private var pendingRequestPost: HitPost?

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.hits) { post in
                    PostPreviewCard(post: post,
                                    showConfirm: false,
                                    onConfirm: {},
                                    showJoinButton: post.userID != Auth.auth().currentUser?.uid,
                                    onJoinRequest: {
                                        if viewModel.isRequestingLate(for: post) {
                                            pendingRequestPost = post
                                            lateRequestWarning = true
                                        } else {
                                            viewModel.sendRequest(for: post)
                                        }
                                    },
                                    isRequested: viewModel.requestedPostIDs.contains(post.id),
                                    onCancelRequest: { viewModel.cancelRequest(for: post) },
                                    isAccepted: viewModel.acceptedPostIDs.contains(post.id)
                    )}
            }
            .refreshable {
                await viewModel.fetchPostsAsync()
            }
            .task {
                viewModel.fetchPosts()
                viewModel.fetchExistingRequests()
                viewModel.fetchAcceptedRequests()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showFilter = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showFilter, onDismiss: {
                viewModel.fetchPosts()
            }) {
                FilterView(isNewest: $viewModel.isNewest,
                           numberOfPeople: $viewModel.numberOfPeople,
                           isFriends: $viewModel.isFriends,
                           utrRange: $viewModel.utrRange,
                           ustaRange: $viewModel.ustaRange
                )
                .presentationDetents([.fraction(0.35)])
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Requesting Late", isPresented: $lateRequestWarning) {
                Button("Cancel", role: .cancel) {
                    pendingRequestPost = nil
                }
                Button("Request Anyway") {
                    if let post = pendingRequestPost {
                        viewModel.sendRequest(for: post)
                    }
                    pendingRequestPost = nil
                }
            } message: {
                Text(lateRequestMessage)
            }
        }
    }

    private var lateRequestMessage: String {
        guard let post = pendingRequestPost else {
            return "Request anyway?"
        }
        let minutesRemaining = viewModel.minutesUntilHit(for: post)
        if minutesRemaining > 0 {
            return "This hit starts in \(minutesRemaining) minute\(minutesRemaining == 1 ? "" : "s"). The host may already have plans set, but they could still accept you."
        } else {
            return "This hit's start time has already passed."
        }
    }
}


#Preview {
    HitsView()
}
