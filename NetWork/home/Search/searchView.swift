//
//  searchView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/20/25.
//

import SwiftUI

struct searchView: View {
    @StateObject var viewModel = searchViewModel() // creates an instance of serachViewModel

    var body: some View {
        VStack {
            
            // TODO: make a better looking search page
            
            TextField("Search for players...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search") {
                viewModel.searchUsers()
            }
            .padding()

            // makes a list of the searchResults
            List(viewModel.searchResults) { user in
                StubView(user: user)
            }
        }
    }
}
#Preview {
    searchView()
}


