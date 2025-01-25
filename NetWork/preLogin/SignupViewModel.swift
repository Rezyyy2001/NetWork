//
//  SignupViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 12/23/24.
//

import SwiftUI
import FirebaseAuth

final class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var name = ""
    @Published var birthday: Date?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showHomeView = false
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty, let birthday = birthday else {
            errorMessage = "All fields are required."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true
        Task {
            do {
                let userData = try await AuthenticationManager.shared.signUp(name: name, email: email, password: password, birthday: birthday)
                print("Account created successfully: \(userData.uid)")
                isLoading = false
                showHomeView = true
            } catch {
                errorMessage = error.localizedDescription
                print("Error signing up: \(error)")
                isLoading = false
            }
        }
    }
}
