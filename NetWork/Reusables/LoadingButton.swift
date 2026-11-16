//
//  LoadingButton.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/16/26.
//

import SwiftUI

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 80)
            .padding(.vertical, 18)
            .padding(.horizontal, 50)
            .background(Color(.systemBlue))
            .cornerRadius(10)
        }
        .disabled(isLoading)
    }
}
