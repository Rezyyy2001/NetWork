//
//  ScaleLayout.swift
//  NetWork
//
//  Created by Rezka Yuspi on 8/16/26.
//

import SwiftUI

struct ScaledLayout: Layout {
    var scale: CGFloat
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        guard let subview = subviews.first else { return .zero }
        let size = subview.sizeThatFits(childProposal(proposal))
        return CGSize(width: size.width * scale, height: size.height * scale)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard let subview = subviews.first else { return }
        subview.place(
            at: CGPoint(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: childProposal(proposal)
        )
    }

    private func childProposal(_ proposal: ProposedViewSize) -> ProposedViewSize {
        ProposedViewSize(
            width: proposal.width.map { $0 / scale },
            height: proposal.height.map { $0 / scale }
        )
    }
}

extension View {
    func scaledLayout(_ scale: CGFloat) -> some View {
        ScaledLayout(scale: scale) {
            self.scaleEffect(scale)
        }
    }
}
