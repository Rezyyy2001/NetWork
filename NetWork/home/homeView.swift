//
//  homeView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct homeView: View {
    @State private var tabselection = 1
    
    let homeTabItems: [(image: String, title: String)] = [
        ("figure.tennis", "Friends"),
        ("globe", "Local"),
        ("plus.app", "Post"),
        ("hand.wave", "Services"),
        ("person", "Profile")
    ]
    
    var body: some View {
     
        ZStack {
            //Color(red: 30/255, green: 143/255, blue: 213/255)
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
            
                Spacer()
                if tabselection == 1 {
                    friendsView()
                } else if tabselection == 2 {
                    localView()
                } else if tabselection == 3 {
                    postView()
                } else if tabselection == 4 {
                    serviceView()
                } else if tabselection == 5 {
                    profileView()
                }
                Spacer()
                CustomTabView(tabSelection: $tabselection, items: homeTabItems)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    homeView()
}
