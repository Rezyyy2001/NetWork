//
//  profileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI

//@MainActor // All properties update on the main thread by default
           // DispatchQueue.main.async is uneccessary

final class ProfileViewModel: ObservableObject, userProfileDataProvider {
    @Published var showSettings = false // Moved UI state to ViewModel
    @Published var errorMessage: String? = nil // For error handling
    
    @Published var user: AuthDataResultModel? = nil // stores the authenticated user's data
    
    @Published var utr: Double? = nil
    @Published var usta: Double? = nil
    @Published var bio: String? = nil
    @Published var usualSpot: String? = nil
    @Published var age: Int = 0
    
    var name: String {
        user?.displayName ?? "Unknown"
    }
     
    // This fetches the updated @Published properties from authentiction manager
    func fetchUserProfile() async {
        do {
            let (userData, fetchedUTR, fetchedUSTA, fetchedBio, fetchedUsualSpot, birthday) = try await AuthenticationManager.shared.getUserProfile()
            
            //stores the retrieved data in @Published var
            self.user = userData
            self.utr = fetchedUTR
            self.usta = fetchedUSTA
            self.bio = fetchedBio
            self.usualSpot = fetchedUsualSpot
            
            if let birthdate = birthday {
                self.age = calculateAge(from: birthdate)
            }
        } catch {
            self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
        }
    }
     
    // converst timestamp to int
    private func calculateAge(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: Date())
        return ageComponents.year ?? 0
    }
}
