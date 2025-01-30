//
//  profileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: AuthDataResultModel? = nil
    @Published var showSettings = false // Moved UI state to ViewModel
    @Published var errorMessage: String? = nil // For error handling

    func start() async {
        do {
            user = try await AuthenticationManager.shared.getAuthenticatedUser()
        } catch {
            errorMessage = "Failed to fetch user: \(error.localizedDescription)"
        }
    }
}
