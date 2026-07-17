//
//  EditServiceViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/14/26.
//

@preconcurrency import FirebaseFirestore
import Foundation

@MainActor
final class EditServiceViewModel: ObservableObject {
    
    @Published var isActive: Bool = false
    @Published var serviceType: ServiceType = .stringing
    @Published var pricing: Int = 0
    @Published var city: String = ""
    @Published var description: String = ""
    @Published var chips: [ServiceTag] = []
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    @Published var insta: String = ""
    
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    @Published var isEditingService: Bool = false
    
    @Published var selectedServiceType: ServiceType? = nil
    
    private var cardID: String? = nil
    
    private let service = BusinessCardService()
    
    func saveBusinessCard() async {
        do {
            try await service.saveBusinessCard(
                cardID: cardID,
                isActive: isActive,
                city: city,
                serviceType: serviceType.rawValue,
                pricing: pricing,
                likeCount: 0,
                description: description,
                chips: chips.map { $0.rawValue },
                phoneNumber: phoneNumber,
                email: email,
                insta: insta)
            
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
                self.isActive = card.isActive
                self.city = card.city
                self.pricing = card.pricing
                self.description = card.description
                self.chips = card.chips ?? []
                self.phoneNumber = card.phoneNumber ?? ""
                self.email = card.email ?? ""
                self.insta = card.insta ?? ""
            }
        } catch {
            errorMessage = "Could not find card"
        }
    }
}
