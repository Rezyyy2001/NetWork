//
//  EditServiceViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/14/26.
//

import Foundation
import FirebaseStorage
import UIKit
import FirebaseAuth

@MainActor
final class EditServiceViewModel: ObservableObject {
    
    @Published var isActive: Bool = false
    @Published var serviceType: ServiceType = .stringing
    @Published var pricing: Int = 0
    @Published var city: String = ""
    @Published var description: String = ""
    @Published var selectedTags: [ServiceTag] = []
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    @Published var insta: String = ""
    @Published var backgroundPic: String? = nil
    
    @Published var selectedBackgroundPic: UIImage? = nil
    
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    @Published var isEditingService: Bool = false
    
    @Published var selectedServiceType: ServiceType? = nil
    
    private var cardID: String? = nil
    private var likeCount: Int = 0

   
    
    private let service = BusinessCardService()
    
    func saveBusinessCard() async {
        do {
            let bgURL = await changePhoto()
            try await service.saveBusinessCard(
                cardID: cardID,
                isActive: isActive,
                city: city,
                serviceType: serviceType.rawValue,
                pricing: pricing,
                likeCount: likeCount,
                description: description,
                tags: selectedTags.map { $0.rawValue },
                phoneNumber: phoneNumber,
                email: email,
                insta: insta,
                backgroundPic: bgURL)
            
            self.isEditingService = false
        } catch {
            errorMessage = "Could not save"
            showErrorAlert = true
        }
    }
    
    func fetchUserCard(for serviceType: ServiceType) async {
        do {
            let cards = try await service.fetchUserCard()
            if let card = cards.first(where: { $0.serviceType == serviceType }) {
                cardID = card.id
                likeCount = card.likeCount
                self.isActive = card.isActive
                self.city = card.city
                self.pricing = card.pricing
                self.description = card.description
                self.selectedTags = card.tags
                self.phoneNumber = card.phoneNumber ?? ""
                self.email = card.email ?? ""
                self.insta = card.insta ?? ""
                self.backgroundPic = card.backgroundPic
            } else {
                cardID = nil
                likeCount = 0
                self.isActive = false
                self.city = ""
                self.pricing = 0
                self.description = ""
                self.selectedTags = []
                self.phoneNumber = ""
                self.email = ""
                self.insta = ""
                self.backgroundPic = nil
            }
        } catch {
            errorMessage = "Could not find card"
            showErrorAlert = true
        }
    }
    
    func changePhoto() async -> String? {
        guard let image = selectedBackgroundPic,
              let data = image.jpegData(compressionQuality: 0.8) else {
                return backgroundPic }
        let storageRef = Storage.storage().reference().child("businessCards/\(Auth.auth().currentUser?.uid ?? "")/background.jpg")
        do {
            _ = try? await storageRef.putDataAsync(data)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            return nil
        }
    }
}
