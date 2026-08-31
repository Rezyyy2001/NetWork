//
//  CardStackView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/28/26.
//

import SwiftUI

struct CardStackView: View {
    let cards: [BusinessCard]
    var onSwipeLeft:  (BusinessCard) -> Void = { _ in }
    var onSwipeRight: (BusinessCard) -> Void = { _ in }

    @State private var offset: CGSize = .zero
    @State private var draggedCardID: String?

    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let isTop = index == cards.count - 1
                let isSecond = index == cards.count - 2
                let isDragging = card.id == draggedCardID

                BusinessCardView(card: card)
                    .scaleEffect(isTop ? 1.0 : 0.95)
                    .offset(isDragging ? offset : CGSize(width: 0, height: CGFloat(cards.count - 1 - index) * 10))
                    .rotation3DEffect(.degrees(isDragging ? Double(offset.width / 20) : 0), axis: (x: 0, y: 0, z: 1))
                    .opacity(
                        isTop ? 1.0 :
                        (isSecond && draggedCardID != nil) ? Double(abs(offset.width)) / 150 : 0
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                draggedCardID = card.id
                                offset = value.translation
                            }
                            .onEnded { value in
                                if value.translation.width > 150 {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        offset = CGSize(width: 500, height: value.translation.height)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onSwipeRight(card)
                                        offset = .zero
                                        draggedCardID = nil
                                    }
                                } else if value.translation.width < -150 {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        offset = CGSize(width: -500, height: value.translation.height)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onSwipeLeft(card)
                                        offset = .zero
                                        draggedCardID = nil
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        offset = .zero
                                        draggedCardID = nil
                                    }
                                }
                            }
                    )
            }
        }
        .animation(.easeOut(duration: 0.3), value: cards.count)
    }
}
