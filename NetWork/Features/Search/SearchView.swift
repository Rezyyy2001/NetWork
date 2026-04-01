//
//  searchView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/20/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel() // creates an instance of serachViewModel
    
    @State private var selectedUser: UserStub?  // Track selected user
    //@State private var isShowingProfile = false // Control navigation
    

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(10)

                TextField("Search for players...", text: $viewModel.searchText)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            .padding(.horizontal)
            .padding()

            // Search Button
            Button(action: {
                viewModel.searchUsers()
            }) {
                Text("Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(10)

            // Search Results
            List(viewModel.searchResults) { user in
                StubView(user: user) {
                    selectedUser = user // Store selected user
                }
                .listRowBackground(Color.clear) // Ensures it doesn’t apply default background
            }
            .listStyle(PlainListStyle())
            .listStyle(PlainListStyle())
        }
        .padding(.top, 10)
        .navigationDestination(item: $selectedUser) { user in
            UserProfileView(userID: user.id) // Navigate on selection
                .onAppear {
                    print("Navigating to userProfileView for \(user.id)")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    SearchView()
}
