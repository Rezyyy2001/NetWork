//
//  LoginSignupView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 9/29/24.
//

import SwiftUI


struct LoginSignupView: View {
    @State private var tabselection = 1
    
    let tabBarItems: [(image: String, title: String)] = [
        ("person", "Login"),
        ("clipboard", "SignUp")
    ]
    
    var body: some View {
        ZStack {
            //Color(red: 30/255, green: 143/255, blue: 213/255) (pastel blue)
            Color(.green)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                CustomTabView(tabSelection: $tabselection, items: tabBarItems)
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
