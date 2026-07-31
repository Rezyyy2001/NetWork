//
//  homeView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            HitsView()
                .tabItem { Label("Hits", systemImage: "figure.tennis") }
            ServiceView()
                .tabItem { Label("Service", systemImage: "globe") }
            PostView()
                .tabItem { Label("Post", systemImage: "plus.app") }
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}

#Preview {
    HomeView()
}

