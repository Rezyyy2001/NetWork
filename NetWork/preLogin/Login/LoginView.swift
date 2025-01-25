//
//  LoginView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/21/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 24) { // spacing between input fields
                    InputView(text: $viewModel.email,
                              title: "Email address",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                    
                    InputView(text: $viewModel.password,
                              title: "Password",
                              placeholder: "Enter Password",
                              isSecureField: true)
                        .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                    
                    Button {
                        Task { await viewModel.signIn() }
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
                    .navigationDestination(isPresented: $viewModel.showHomeView) {
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
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    LoginView()
}

