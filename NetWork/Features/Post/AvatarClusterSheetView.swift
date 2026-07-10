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
                        if profile.status == "accepted" || acceptedIDs.contains(profile.documentID) {
                            Text("Accepted")
                                .foregroundColor(.gray)
                        } else {
                            Button("Accept") {
                                acceptedIDs.insert(profile.documentID)
                                onAccept(profile.documentID)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
    }
}
