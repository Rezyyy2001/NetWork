//
//  searchView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/20/25.
//

import SwiftUI

struct searchView: View {
    @StateObject var viewModel = searchViewModel() // creates an instance of serachViewModel
    
    @State private var selectedUser: userStub?  // Track selected user
    @State private var isShowingProfile = false // Control navigation

    var body: some View {
        VStack {
            
            // TODO: make a better looking search page
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(10)
                
                TextField("Search for players...", text: $viewModel.searchText)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    //.padding()
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            .padding(.horizontal)
            .padding()
                
            Button (action: {
                viewModel.searchUsers()
            }) {
                Text("Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(10)
            // makes a list of the searchResults
            List(viewModel.searchResults) { user in
                StubView(user: user) {
                    selectedUser = user
                    isShowingProfile = true
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top, 10)
    }
    
}
#Preview {
    searchView()
}


