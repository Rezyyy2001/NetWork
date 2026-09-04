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
    let cardWidth: CGFloat

    // TODO: If user has max sized text, find a way to fit text without ...
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                KFImage(URL(string: card.backgroundPic ?? ""))
                    .placeholder { Color(.systemGray5) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: 300)
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
                                    .font(.largeTitle)
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
                .frame(width: cardWidth, height: 300)
            }
            .frame(height: 300)

            VStack(spacing: 2) {
                Text(card.description)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .padding(.bottom, 0)

                FlowLayout(horizontalSpacing: 6, verticalSpacing: 6) {
                    ForEach(card.tags, id: \.self) { tag in
                        Text(tag.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(.horizontal, 10)

                Divider()

                FlowLayout(horizontalSpacing: 10, verticalSpacing: 6) {
                    ForEach(contacts, id: \.text) { item in
                        Label(item.text, systemImage: item.icon)
                            .font(.caption2)
                            .labelStyle(.titleAndIcon)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
        }
        .frame(width: cardWidth)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }

    private var contacts: [(icon: String, text: String)] {
        [("phone", card.phoneNumber), ("envelope", card.email), ("camera", card.insta)]
            .compactMap { icon, value in
                guard let value, !value.isEmpty else { return nil }
                return (icon, value)
            }
    }
}

struct FlowLayout: Layout {
    var horizontalSpacing: CGFloat = 6
    var verticalSpacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .greatestFiniteMagnitude
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widestRow: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > maxWidth {
                widestRow = max(widestRow, x - horizontalSpacing)
                y += rowHeight + verticalSpacing
                x = 0
                rowHeight = 0
            }
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
        widestRow = max(widestRow, x - horizontalSpacing)

        return CGSize(width: proposal.width ?? max(widestRow, 0), height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX, x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: ProposedViewSize(size))
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
