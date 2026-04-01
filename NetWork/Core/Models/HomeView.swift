//
//  homeView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct HomeView: View {
    @State private var tabselection = 1
    
    let homeTabItems: [(image: String, title: String)] = [
        ("figure.tennis", "Friends"),
        ("globe", "Local"),
        ("plus.app", "Post"),
        ("magnifyingglass", "Search"),
        ("person", "Profile")
    ]
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                VStack {
                    if tabselection == 1 {
                        FriendsView()
                    } else if tabselection == 2 {
                        LocalView()
                    } else if tabselection == 3 {
                        PostView()
                    } else if tabselection == 4 {
                        SearchView()
                    } else if tabselection == 5 {
                        ProfileView()
                    }
                }
                
                CustomTabView(tabSelection: $tabselection, items: homeTabItems)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.white)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    HomeView()
}

