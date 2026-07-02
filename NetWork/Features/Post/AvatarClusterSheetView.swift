//
//  AvatarClusterSheetView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/24/26.
//

import SwiftUI
import Kingfisher

struct AvatarClusterSheetView: View {
    let profiles: [HitRequestProfile]
    let isOwner: Bool

    var body: some View {
        List {
            ForEach(profiles, id: \.documentID) { profile in
                
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
                }
            }
            Spacer()
        }
        .listStyle(.plain)
        .scrollDisabled(true)
    }
}
