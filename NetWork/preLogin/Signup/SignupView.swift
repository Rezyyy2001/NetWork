//
//  SignupView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/21/24.
//

import SwiftUI

struct SignupView: View {

    @StateObject private var viewModel = SignupViewModel() // to tie the signupViewModel logic and userInput
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                InputView(text: $viewModel.name, // binds text to viewModel.name
                          title: "Name",
                          placeholder: "First Last")
                .autocapitalization(.words)
                .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                
                VStack(alignment: .leading, spacing: 8) { // binds date to viewModel.birthday
                    Text("Birthday")
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                        .font(.system(size: 13))
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.birthday ?? Date() },
                            set: { newDate in
                                let currentDate = Date() // so the wheel defaults to today's date
                                if newDate <= currentDate {
                                    viewModel.birthday = newDate
                                }
                            }
                        ),
                        in: ...Date(), // any date up to todays date
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .frame(width: UIScreen.main.bounds.width - 200)
                }
                
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
                
                InputView(text: $viewModel.confirmPassword, // binds text viewModel.confirmPassword for authentication
                          title: "Confirm Password",
                          placeholder: "Re-enter Password",
                          isSecureField: true)
                .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                
                Button {
                    viewModel.signUp() // calls viewModel.signUp when button tapped
                } label: {
                    // TODO: Add a simple loading screen
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 200, height: 50)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                }
                .padding(.top, 24)
                .navigationDestination(isPresented: $viewModel.showHomeView) { // calls viewModel.showHomeView as true
                    homeView() // if true navigates to homeView
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

#Preview {
    SignupView()
}
