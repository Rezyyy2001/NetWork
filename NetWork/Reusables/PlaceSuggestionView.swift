//
//  PlaceSuggestionView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/9/26.
//

import SwiftUI

struct PlaceSuggestionView: View {
    let suggestion: PlaceSuggestion
    var onTap: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle") // Placeholder for profile pic
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
            Text(suggestion.description)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .onTapGesture {
            onTap() // Handle tap for navigation
        }
    }
}
