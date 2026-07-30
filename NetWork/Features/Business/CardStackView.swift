//
//  CardStackView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/28/26.
//

import SwiftUI

struct CardStackView: View {
    let cards: [BusinessCard]
    @State private var localCards: [BusinessCard] = []
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            ForEach(localCards.indices, id: \.self) { index in
                BusinessCardView(card: localCards[index])
                    .scaleEffect(index == localCards.count - 1 ? 1.0 : 0.95)
                    .offset(index == localCards.count - 1 ? offset : CGSize(width: 0, height: CGFloat(localCards.count - 1 - index) * 10))
                    .rotation3DEffect(.degrees(index == localCards.count - 1 ? Double(offset.width / 20) : 0), axis: (x: 0, y: 0, z: 1))
                    .opacity(index == localCards.count - 1 ? 1.0 : Double(abs(offset.width)) / 150)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                            }
                            .onEnded { value in
                                if value.translation.width > 150 {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        offset = CGSize(width: 500, height: value.translation.height)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        localCards.removeLast()
                                        offset = .zero
                                    }
                                } else if value.translation.width < -150 {
                                      withAnimation(.easeOut(duration: 0.3)) {
                                          offset = CGSize(width: -500, height: value.translation.height)
                                      }
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                          localCards.removeLast()
                                          offset = .zero
                                      }
                                } else {
                                    withAnimation(.spring()) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
            }
        }
        .animation(.easeOut(duration: 0.3), value: localCards.count)
        .onAppear { localCards = cards }
        .onChange(of: cards) { _, newValue in localCards = newValue }
    }
}
