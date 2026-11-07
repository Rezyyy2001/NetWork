//
//  AvatarClusterSheetView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/24/26.
//

import SwiftUI
import Kingfisher

struct AvatarClusterSheetView: View {
    @ObservedObject var viewModel: AvatarClusterViewModel
    
    @State private var acceptedIDs: Set<String> = []
    @State private var showLateAcceptAlert: Bool = false
    @State private var pendingAcceptID: String?

    var onAccept: (String) -> Void

    var body: some View {
        List {
            ForEach(viewModel.profiles, id: \.documentID) { profile in
                
                HStack {
                    KFImage(URL(string: profile.userProfile.profilePictureURL ?? ""))
                        .placeholder {
                            Image(systemName: "person")
                                .foregroundColor(Color.brandBlue)
                                .font(.system(size: 25))
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.brandBlue, lineWidth: 2))
                    
                    Text(profile.userProfile.name)
                        .font(.headline)
                    
                    Spacer()
                    if viewModel.isOwner {
                        if profile.status == .accepted || acceptedIDs.contains(profile.documentID) {
                            Text("Accepted")
                                .foregroundColor(.gray)
                        } else {
                            Button("Accept") {
                                if viewModel.isAcceptingLate {
                                    pendingAcceptID = profile.documentID
                                    showLateAcceptAlert = true
                                } else {
                                    accept(profile.documentID)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .alert("Accepting Late", isPresented: $showLateAcceptAlert) {
            Button("Cancel", role: .cancel) {
                pendingAcceptID = nil
            }
            Button("Accept Anyway") {
                if let id = pendingAcceptID {
                    accept(id)
                }
                pendingAcceptID = nil
            }
        } message: {
            Text(lateAcceptMessage)
        }
    }

    private func accept(_ documentID: String) {
        acceptedIDs.insert(documentID)
        onAccept(documentID)
    }

    private var lateAcceptMessage: String {
        let minutesRemaining = viewModel.minutesUntilHit
        if minutesRemaining > 0 {
            return "This hit starts in \(minutesRemaining) minute\(minutesRemaining == 1 ? "" : "s"). Accept anyway?"
        } else {
            return "This hit's start time has already passed. Accept anyway?"
        }
    }
}
