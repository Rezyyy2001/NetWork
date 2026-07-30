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
                            .cornerRadius(20)

                        Spacer()
                        Text("$\(card.pricing)/hr")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.callout)
                            .bold()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
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
                        .cornerRadius(10)

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
                        .cornerRadius(10)
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
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 10)

                Divider()

                HStack(spacing: 2) {
                    if let phone = card.phoneNumber, !phone.isEmpty {
                        Image(systemName: "phone")
                            .font(.system(size: 10))
                        Text(phone)
                            .font(.system(size: 10))
                    }
                    if let email = card.email, !email.isEmpty {
                        Divider()
                            .padding(.horizontal, 4)
                        Image(systemName: "envelope")
                            .font(.system(size: 10))
                        Text(email)
                            .font(.system(size: 10))
                    }
                    if let insta = card.insta, !insta.isEmpty {
                        Divider()
                            .padding(.horizontal, 4)
                        Image(systemName: "camera")
                            .font(.system(size: 10))
                        Text(insta)
                            .font(.system(size: 10))
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
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    BusinessCardView(card: BusinessCard(
        id: "1",
        userID: "user1",
        isActive: true,
        serviceType: .lessons,
        pricing: 25,
        city: "Somerville",
        likeCount: 10,
        description: "Hello! My name is Rez, a Umass Boston tennis player alum. I have been coaching for over 10 years now at many different establishments. I love working with all ages and can tailor my approach to fit your specific needs.",
        tags: [.adults, .juniors, .d3, .tenYears, .beginnerFriendly, .collegeTennis, .certifiedCoach, .clubAffiliated, .groupLessons, .weekdays],
        phoneNumber: "123-123-1234",
        email: "test@email.com",
        insta: "@rezkaizasian",
        cardName: "Rezka Yuspi",
        profilePicture: "https://firebasestorage.googleapis.com:443/v0/b/network-362fe.firebasestorage.app/o/users%2F9qVSt63nrjaqiBm79ZNoOxM7AFd2.jpg?alt=media&token=39bb852a-f922-483e-9860-492b7a50fc6e"
        ,
        backgroundPic: "https://firebasestorage.googleapis.com:443/v0/b/network-362fe.firebasestorage.app/o/businessCards%2Fanp5ZM2x7OexJzy2iWJpapXzD1P2%2Fbackground.jpg?alt=media&token=565ce0db-e0c8-47c3-be8a-bc252d0237a2"
    ))
}
