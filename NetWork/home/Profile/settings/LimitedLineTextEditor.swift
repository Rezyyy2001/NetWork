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
            TextEditor(text: $text)
                .padding(.horizontal, 8)
                .frame(height: lineHeight * CGFloat(max(4, min(lineCount(text), lineLimit))))
                .font(.custom("Monaco", size: 14))
                .scrollDisabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .background(Color.clear)
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
    }

    private func lineCount(_ text: String) -> Int {
        text.components(separatedBy: .newlines).reduce(0) { count, line in
            let lineLength = line.count
            let approxCharsPerLine = 45
            return count + max(1, (lineLength / approxCharsPerLine) + (lineLength % approxCharsPerLine > 0 ? 1 : 0))
        }
    }
}


/// There was an issue with how i first approached making a placeholder for the texteditor. I got it to work initially with editProfileSection but when I tried to reuse it in postView the placeholder would not show.
/// Initially thought that maybe it was because of the public of private class causeing the issue which was not the case. Got rid of the GroupBox which was also not the case. ScrollView which was also not the case.
/// Made it look exactly like editProfileSection and it still did not show the placeholder. Deduced that it had something to do with the Navigation hierarchy and the ZStack which messed up the ordering of the ZStack.
