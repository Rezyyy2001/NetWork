//
//  SignupViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 12/23/24.
//

import SwiftUI
import FirebaseAuth

final class SignupViewModel: ObservableObject { // observableObject allows the changes to properties
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var name = ""
    @Published var birthday: Date?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showHomeView = false
    @Published var usualSpot = ""
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty, let birthday = birthday else { // insures that all these fields are filled
            errorMessage = "All fields are required."
            return
        }
        
        guard password == confirmPassword else { // seperate error message for password matching
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true // indicates onging signUp process
        Task {
            do {
                let userData = try await AuthenticationManager.shared.signUp(name: name, email: email, password: password, birthday: birthday, usualSpot: usualSpot) // calls signUp
                print("Account created successfully: \(userData.uid)")
                isLoading = false
                showHomeView = true // after account created shows home view
            } catch {
                errorMessage = error.localizedDescription
                print("Error signing up: \(error)")
                isLoading = false
            }
        }
    }
}
