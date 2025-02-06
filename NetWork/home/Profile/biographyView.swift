//
//  biographyView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/5/25.
//

import SwiftUI

struct BiographyView: View {
    var biography: String? // Optional biography text

    var body: some View {
        VStack {
            Text(biography?.isEmpty == false ? biography! : "Biography") // Uses provided text or default
                .padding()
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    VStack {
        BiographyView(biography: nil) // Shows "Biography"
        BiographyView(biography: "") // Still shows "Biography"
        BiographyView(biography: "I love playing tennis and coding!") // Shows user input
    }
}

