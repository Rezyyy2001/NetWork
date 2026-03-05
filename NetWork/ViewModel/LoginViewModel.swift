//
//  LoginViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 12/22/24.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject { // allows SwiftUI views to observe changes to its properties
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showHomeView = false
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and Password cannot be empty."
            return
        }
        
        isLoading = true
        
        do {
            let userData = try await AuthenticationManager.shared.signIn(email: email, password: password) // checks to see if userdata for log in matches
            print("Successfully logged in: \(userData.uid)")
            isLoading = false
            showHomeView = true // Trigger navigation
        } catch {
            errorMessage = error.localizedDescription
            print("Error signing in: \(error)")
            isLoading = false // resets the isLoading
        }
    }
}

