//
//  LoginSignupView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 9/29/24.
//

import SwiftUI


struct LoginSignupView: View {
    @State var tabselection = 1 // variable to track which tab is selected, 1 is default
    
    let tabBarItems: [(image: String, title: String)] = [ // tabBar is a list of tuples
        ("person", "Login"),
        ("clipboard", "SignUp")
    ]
    
    var body: some View {
        ZStack {
            //Color(red: 30/255, green: 143/255, blue: 213/255) (pastel blue)
            Color(.green)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                CustomTabView(tabSelection: $tabselection, items: tabBarItems) // a customTabview that switches between the items in tabBar
                Spacer()
                if tabselection == 1 {
                    LoginView()
                } else if tabselection == 2 {
                    SignupView()
                }
                Spacer()
            }
            .padding(.top)
        }
    }
}

#Preview {
    LoginSignupView()
}
