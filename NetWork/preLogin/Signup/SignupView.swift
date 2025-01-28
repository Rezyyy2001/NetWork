//
//  SignupView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/21/24.
//

import SwiftUI

struct SignupView: View {

    @StateObject private var viewModel = SignupViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 24) {
                    InputView(text: $viewModel.name,
                              title: "Name",
                              placeholder: "First Last")
                    .autocapitalization(.words)
                    .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                    /*
                    InputView(text: $viewModel.birthday,
                              title: "Birthday",
                              placeholder: "month/day/year")
                    .autocapitalization(.words)
                    .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                    */
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Birthday")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                            .font(.system(size: 13))
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { viewModel.birthday ?? Date() },
                                set: { viewModel.birthday = $0 }
                            ),
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .frame(width: UIScreen.main.bounds.width - 200)
                    }
                    
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
                    
                    InputView(text: $viewModel.confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Re-enter Password",
                              isSecureField: true)
                    .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                    
                    Button {
                        viewModel.signUp()
                    } label: {
                        // add loading screen
                        Text("SIGN UP")
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
    SignupView()
}
