//
//  friendButtonView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/9/25.
//

import SwiftUI

struct friendButtonView: View {
    var body: some View {
        Button(action: {
            print("Add friend button clicked")
        }) {
            Text("Add Friend")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                
        }
        .padding()
    }
}

#Preview {
    friendButtonView()
}
