//
//  userProfileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import Foundation
import FirebaseFirestore

class userProfileViewModel: ObservableObject, userProfileDataProvider {
    
    //@Published var name: String = "Loading..."
    @Published var displayName: String = "Loading..."
    @Published var bio: String? = "No bio available."
    @Published var usualSpot: String? = "Unknown location."
    @Published var utr: Double? = 0.0
    @Published var usta: Double? = 0.0
    
    private let userID: String
    private let db = Firestore.firestore()
    
    var name: String {
        displayName
    }
    
    init(userID: String) {
        self.userID = userID
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found for user \(self.userID)")
                return
            }
            
            DispatchQueue.main.async {
                self.displayName = data["name"] as? String ?? "Unknown"
                self.bio = data["bio"] as? String ?? "No bio available."
                self.usualSpot = data["usualSpot"] as? String ?? "Unknown location."
                self.utr = data["UTR"] as? Double ?? 0.0
                self.usta = data["USTA"] as? Double ?? 0.0
            }
        }
    }
}
