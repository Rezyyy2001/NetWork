//
//  userProfileViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import Foundation
import FirebaseFirestore

class UserProfileViewModel: ObservableObject, UserProfileDataProvider {
    
    // userProfileDataProvider ensures that the properties are the correct type
    @Published var displayName: String = "Loading..."
    @Published var bio: String? = "No bio available."
    @Published var usualSpot: String? = "Unknown location."
    @Published var utr: Double? = 0.0
    @Published var usta: Double? = 0.0
    @Published var age: Int = 0
    
    @Published var friendshipStatus: friendshipStatus = .none

    private let userID: String
    private let db = Firestore.firestore()
    
    enum friendshipStatus: String {
        case none
        case sent
        case recieved
        case friends
    }
    
    var uid: String {
        userID
    }
    
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
                
                if let timestamp = data["birthday"] as? Timestamp {
                    self.age = self.calculateAge(from: timestamp.dateValue())
                }
            }
        }
    }
    private func calculateAge(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: Date())
        return ageComponents.year ?? 0
    }
}
