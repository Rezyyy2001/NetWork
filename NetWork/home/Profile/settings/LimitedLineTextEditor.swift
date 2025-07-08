//
//  LimitedLineTextEditor.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/7/25.
//

import SwiftUI

struct LimitedLineTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let lineLimit: Int
    let lineHeight: CGFloat = 20

    @State private var lastValidText: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 14)
                    .padding(.top, 8)
                    .font(.custom("Monaco", size: 14))
            }

            TextEditor(text: $text)
                .padding(.horizontal, 8)
                .frame(height: lineHeight * CGFloat(max(4, min(lineCount(text), lineLimit))))
                .background(Color.clear)
                .scrollDisabled(true)
                .font(.custom("Monaco", size: 14))
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: text) { oldValue, newValue in
                    let currentLines = lineCount(newValue)
                    if currentLines <= lineLimit {
                        lastValidText = newValue
                    } else {
                        text = lastValidText
                    }
                }
        }
    }
    
    // Counts the number of visual lines (based on \n and wrapping)
    private func lineCount(_ text: String) -> Int {
        text.components(separatedBy: .newlines).reduce(0) { count, line in
            let lineLength = line.count
            let approxCharsPerLine = 45 // rough approximation for average width
            return count + max(1, (lineLength / approxCharsPerLine) + (lineLength % approxCharsPerLine > 0 ? 1 : 0))
        }
    }
}
