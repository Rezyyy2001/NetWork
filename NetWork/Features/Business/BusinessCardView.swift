//
//  BusinessCardView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/19/26.
//

import SwiftUI
import Kingfisher

struct BusinessCardView: View {
    let card: BusinessCard
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                KFImage(URL(string: card.backgroundPic ?? ""))
                    .placeholder { Color(.systemGray5) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                    .clipped()
                
                VStack {
                    HStack {
                        Text(card.serviceType.rawValue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.callout)
                            .bold()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Spacer()
                        Text("$\(card.pricing)/hr")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.callout)
                            .bold()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(10)
                    Spacer()
                    
                    HStack {
                        KFImage(URL(string: card.profilePicture ?? ""))
                            .placeholder {
                                Image(systemName: "person")
                                    .foregroundColor(Color.brandBlue)
                                    .font(.system(size: 35))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.brandBlue, lineWidth: 2))
                        
                        VStack(alignment: .leading) {
                            Text(card.cardName)
                                .font(.title3.bold())
                            Text(card.city)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                        VStack {
                            Text("Likes")
                                .bold()
                            Text("\(card.likeCount)")
                                .bold()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 300)
            }
            .frame(height: 300)
            
            VStack(spacing: 2) {
                Text(card.description)
                    .font(.system(size: 12))
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .padding(.bottom, 0)
                
                // TODO: WrappingHStack or some other efficient chips lineup
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 6) {
                    ForEach(card.tags, id: \.self) { tag in
                        Text(tag.rawValue)
                            .font(.system(size: 10))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(.horizontal, 10)
                
                Divider()
                
                HStack(spacing: 2) {
                    if let phone = card.phoneNumber, !phone.isEmpty {
                        ContactItem(icon: "phone", text: phone)
                    }
                    if let email = card.email, !email.isEmpty {
                        Divider().padding(.horizontal, 4)
                        ContactItem(icon: "envelope", text: email)
                    }
                    if let insta = card.insta, !insta.isEmpty {
                        Divider().padding(.horizontal, 4)
                        ContactItem(icon: "camera", text: insta)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
    
    private struct ContactItem: View {
        let icon: String
        let text: String
        var body: some View {
            Image(systemName: icon).font(.system(size: 10))
            Text(text).font(.system(size: 10))
        }
    }
}
