//
//  LoginView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/21/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel() // creates an instance of LoginViewModel which manages authentication
    
    var body: some View {
        VStack {
            VStack(spacing: 24) { // spacing between input fields
                InputView(text: $viewModel.email, // binds text to viewModel.email
                          title: "Email address",
                          placeholder: "name@example.com")
                    .autocapitalization(.none)
                    .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                
                InputView(text: $viewModel.password, // binds text to viewModel.password
                          title: "Password",
                          placeholder: "Enter Password",
                          isSecureField: true)
                    .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                
                Button {
                    Task { await viewModel.signIn() } // calls viewModel.signIn for async execution
                } label: {
                    // add a loading screen
                    Text("LOG IN")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                }
                .padding(.top, 24)
                .navigationDestination(isPresented: $viewModel.showHomeView) { // navigates to homeView
                    homeView()
                }
            
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(16)
            )
            .padding(.horizontal, 40)
            .padding(.top, 100)
            
            Spacer()
            
            if let errorMessage = viewModel.errorMessage { // if viewModel.errorMessage is not nil it will display the correct error message
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true) // the back button be gone
    }
}

#Preview {
    LoginView()
}

