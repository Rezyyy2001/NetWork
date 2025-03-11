//
//  infoView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/31/25.
//
import SwiftUI

struct infoView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack {
            Label(viewModel.usualSpot ?? "Usual Spot", systemImage: "mappin.circle.fill")
                .foregroundColor(.gray)
                
            Label("age", systemImage: "person.fill")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    NavigationStack {
        profileView()
    }
}
