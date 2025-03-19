//
//  profileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI

@MainActor // All properties update on the main thread by default
           // DispatchQueue.main.async is uneccessary
final class ProfileViewModel: ObservableObject {
    @Published var showSettings = false // Moved UI state to ViewModel
    @Published var errorMessage: String? = nil // For error handling
    
    @Published var user: AuthDataResultModel? = nil // stores the authenticated user's data
    @Published var utr: Double? = nil
    @Published var usta: Double? = nil
    @Published var bio: String? = nil
    @Published var usualSpot: String? = nil

     
    // This fetches the updated @Published properties
    func fetchUserProfile() async {
        do {
            let (userData, fetchedUTR, fetchedUSTA, fetchedBio, fetchedUsualSpot) = try await AuthenticationManager.shared.getUserProfile()
            
            //stores the retrieved data in @Published var
            self.user = userData
            self.utr = fetchedUTR
            self.usta = fetchedUSTA
            self.bio = fetchedBio
            self.usualSpot = fetchedUsualSpot
        
        } catch {
            self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
        }
    }
}
