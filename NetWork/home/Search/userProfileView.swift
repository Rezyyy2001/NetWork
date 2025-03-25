//
//  userProfileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import SwiftUI

struct userProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            headerView(viewModel: viewModel)
            infoView(viewModel: viewModel)
            BiographyView(viewModel: viewModel)
            Spacer()
        }
        .padding()
        .navigationTitle("Player Profile")
    }
}
#Preview {
    userProfileView()
}
