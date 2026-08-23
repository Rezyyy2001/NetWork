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
    
    func signIn() {
        Task {
            guard !email.isEmpty, !password.isEmpty else {
                errorMessage = "Email and Password cannot be empty."
                return
            }
            isLoading = true
            do {
                try await AuthenticationManager.shared.signIn(email: email, password: password) // checks to see if userdata for log in matches
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false // resets the isLoading
                return
            }
            
            do {
                _ = try await CurrentUserService.shared.fetchUserProfile()
                isLoading = false
                showHomeView = true // Trigger navigation
            } catch {
                if (error as NSError).code == 404 {
                    // Firestore confirmed there's no profile for this account — a previous
                    // signup never finished. Clean it up instead of leaving them stuck.
                    try? await AuthenticationManager.shared.deleteCurrentUser()
                    errorMessage = "Your account setup didn't finish. Please sign up again."
                } else {
                    // Couldn't verify the profile (network/Firestore issue) — leave the
                    // account alone, this doesn't mean the profile is actually missing.
                    errorMessage = "Could not verify your profile. Please try again."
                }
                isLoading = false
            }
        }
    }
}
