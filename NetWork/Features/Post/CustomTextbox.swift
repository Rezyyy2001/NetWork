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
            Text(text)
                .opacity(0)
                .padding()
                .font(.custom("Monaco", size: 14))
            
            TextEditor(text: $text)
                .padding(.horizontal, 8)
                .font(.custom("Monaco", size: 14))
                .scrollDisabled(true)
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
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.white)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
}
