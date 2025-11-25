//
//  floatingCard.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/6/25.
//

import SwiftUI

struct floatingCard: View {
    @State private var offset: CGSize = .zero // Starting point
    @GestureState private var dragState: CGSize = .zero // Live movement ends at 0
    
    var body: some View {
        Rectangle()
            .fill(Color.pink)
            .frame(width: 300, height: 500)
            .cornerRadius(30)
            .shadow(radius: 10)
        
            // Offset is for the resting place
            // dragstate is for the live motions
            .offset(x: offset.width + dragState.width,
                    y: offset.height + dragState.height)
            
            // Tilts off to the side
            .rotationEffect(.degrees(Double((offset.width + dragState.width) / 20)))
        
            .gesture(
                DragGesture()
                    .updating($dragState) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        offset = value.translation
                    }
            )
            .animation(.spring(), value: dragState)
            .animation(.spring(), value: offset)
    }
}
#Preview {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        floatingCard()
    }
}
