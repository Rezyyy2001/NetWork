//
//  PostPreviewCard.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/12/26.
//

import SwiftUI
import FirebaseAuth

private struct TruncatedKey: PreferenceKey {
    static let defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

struct PostPreviewCard: View {
    let post: HitPost
    
    var showConfirm: Bool = true
    var onConfirm: () -> Void
    
    var showJoinButton: Bool = true
    var onJoinRequest: () -> Void
    
    var isRequested: Bool = false
    var onCancelRequest: () -> Void

    @State private var isExpanded = false
    @State private var isTruncated = false

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d 'at' h:mm a"
        return formatter.string(from: post.date)
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    AsyncImage(url: URL(string: post.profilePictureURL ?? "")) { image in image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "person")
                            .foregroundColor(Color(red: 30/255, green: 143/255, blue: 213/255))
                            .font(.system(size: 25))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(red: 30/255, green: 143/255, blue: 213/255), lineWidth: 2))
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text(post.posterName)
                            .font(.footnote)
                            .bold()
                        if let utr = post.posterUTR {
                            Text("UTR: \(utr, specifier: "%.1f")")
                                .font(.footnote)
                        }
                        if let usta = post.posterUSTA {
                            Text("USTA: \(usta, specifier: "%.1f")")
                                .font(.footnote)
                        }
                    }
                    
                    Spacer()
                    
                    AvatarClusterView(postID: post.id, isOwner: post.userID == Auth.auth().currentUser?.uid)
                    
                    Spacer()
    
                    if showJoinButton {
                        Button {
                            isRequested ? onCancelRequest() : onJoinRequest()
                        } label: {
                            Image(systemName: isRequested ? "minus.circle" : "plus.app")
                                .font(.title)
                                .foregroundColor(isRequested ? .red : .green)
                        }
                    }
                }

                Divider()

                HStack {
                    Text(formattedDate)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text(post.city)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(post.extraInfo)
                    .font(.body)
                    .lineLimit(isExpanded ? nil : 3)
                    .truncationMode(.tail)
                    .overlay(
                        GeometryReader { visibleProxy in
                            Text(post.extraInfo)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                                .hidden()
                                .overlay(
                                    GeometryReader { fullProxy in
                                        Color.clear.preference(
                                            key: TruncatedKey.self,
                                            value: fullProxy.size.height > visibleProxy.size.height
                                        )
                                    }
                                )
                        }
                    )
                    .onPreferenceChange(TruncatedKey.self) { isTruncated = $0 }

                if isTruncated || isExpanded {
                    HStack {
                        Spacer()
                        Button(action: { isExpanded.toggle() }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 8)
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
            .animation(.easeInOut(duration: 0.2), value: isTruncated)

            if showConfirm {
                Button(action: onConfirm) {
                    Text("Post")
                        .fontWeight(.bold)
                        .frame(maxWidth: 100)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
    }
}

#Preview {
    let post = HitPost(
        id: "preview",
        userID: "preview",
        posterName: "Rezka Yuspi",
        posterUTR: 8.5,
        posterUSTA: 4.5,
        location: "Griffith Park Tennis Courts",
        city: "Los Angeles",
        date: Date(),
        extraInfo: "Looking for a hitting partner for some competitive rallies. All levels welcome! Preferably someone with a UTR between 7-10. I usually play baseline but love working on my net game too.",
        numberOfPeople: 2,
        isPublic: true,
        profilePictureURL: ""
        
    )
    ZStack {
        Color.black.opacity(0.7).ignoresSafeArea()
        PostPreviewCard(post: post, onConfirm: {}, onJoinRequest: {}, onCancelRequest: {})
            .padding(.horizontal, 24)
    }
}
