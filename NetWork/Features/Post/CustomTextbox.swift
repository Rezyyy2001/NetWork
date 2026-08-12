//
//  CustomTextbox.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/2/26.
//

import SwiftUI

struct CustomTextbox: View {
    @State private var editorHeight: CGFloat = 34
    
    @Binding var text: String
    let placeholder: String
    var characterLimit: Int? = nil

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("Monaco", size: 14, relativeTo: .body))
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $text)
                    .font(.custom("Monaco", size: 14, relativeTo: .body))
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: editorHeight)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .task {
                        let lineCount = text.components(separatedBy: "\n").count
                        editorHeight = max(34, CGFloat(lineCount) * 22)
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.quaternary, lineWidth: 1)
            )
            .onChange(of: text) { _, newValue in
                if let limit = characterLimit, newValue.count > limit {
                    text = String(newValue.prefix(limit))
                }
            }

            if let limit = characterLimit {
                Text("\(limit - text.count)")
                    .font(.custom("Monaco", size: 12, relativeTo: .caption))
                    .foregroundStyle(text.count >= limit ? .red : .secondary)
                    .monospacedDigit()
            }
        }
    }
}
