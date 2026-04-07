//
//  CustomTextbox.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/2/26.
//

import SwiftUI

struct CustomTextbox: View {
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack(spacing: -10) {
                TextEditor(text: $text)
                    .padding(.horizontal, 8)
                    .font(.custom("Monaco", size: 14))
                    .scrollDisabled(true)
                
                    // Enforces character limit
                    .onChange(of: text) { oldValue, newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
                    .overlay(
                        Group {
                            if text.isEmpty {
                                Text(placeholder)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 14)
                                    .padding(.top, 8)
                                    .font(.custom("Monaco", size: 14))
                                    .transition(.opacity)
                            }
                        },
                        alignment: .topLeading
                    )
                HStack {
                    Spacer()
                    Text("\(characterLimit - text.count)")
                        .font(.custom("Monaco", size: 12))
                        .padding(5)
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.white)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
}
