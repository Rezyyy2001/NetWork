//
//  BackButton.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/30/26.
//

import SwiftUI

struct BackButton: View {
    var padded: Bool = true
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: { dismiss() }) {
            let image = Image(systemName: "arrow.backward")
                .font(.title2)
                .foregroundColor(.blue)

            if padded {
                image
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
            } else {
                image
            }
        }
        .padding(.leading, padded ? 16 : 0)
        .padding(.top, padded ? 16 : 0)
    }
}
