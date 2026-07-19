//
//  BusinessCardService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/13/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct BusinessCardService {
    
    private let db = Firestore.firestore()
    
    func saveBusinessCard(cardID: String?, isActive: Bool, city: String, serviceType: String, pricing: Int, likeCount: Int, description: String, tags: [String], phoneNumber: String?, email: String?, insta: String?) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        let userData: [String: Any] = [
            FirestoreKeys.BusinessCardFields.userID: user.uid,
            FirestoreKeys.BusinessCardFields.isActive: isActive,
            FirestoreKeys.BusinessCardFields.city: city,
            FirestoreKeys.BusinessCardFields.serviceType: serviceType,
            FirestoreKeys.BusinessCardFields.pricing: pricing,
            FirestoreKeys.BusinessCardFields.likeCount: likeCount,
            FirestoreKeys.BusinessCardFields.description: description,
            FirestoreKeys.BusinessCardFields.tags: tags,
            FirestoreKeys.BusinessCardFields.phoneNumber: phoneNumber ?? "",
            FirestoreKeys.BusinessCardFields.email: email ?? "",
            FirestoreKeys.BusinessCardFields.insta: insta ?? ""
        ]
        
        let ref = cardID != nil
            ? Firestore.firestore().collection(FirestoreKeys.Collections.businessCardFields).document(cardID!)
            : Firestore.firestore().collection(FirestoreKeys.Collections.businessCardFields).document()
        try await ref.setData(userData)
    }
    
    func fetchUserCard() async throws -> [BusinessCard] {
        
        let query: Query = db.collection(FirestoreKeys.Collections.businessCardFields)
            .whereField(FirestoreKeys.BusinessCardFields.userID, isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .limit(to: 10)
        
        do {
            let snapshot = try await query.getDocuments()
            
            let card = snapshot.documents.compactMap { doc in
                let userID = doc.data()[FirestoreKeys.BusinessCardFields.userID] as? String ?? ""
                let isActive = doc.data()[FirestoreKeys.BusinessCardFields.isActive] as? Bool ?? false
                let city = doc.data()[FirestoreKeys.BusinessCardFields.city] as? String ?? ""
                let serviceType = ServiceType(rawValue:doc.data()[FirestoreKeys.BusinessCardFields.serviceType] as? String ?? "") ?? .stringing
                let pricing = doc.data()[FirestoreKeys.BusinessCardFields.pricing] as? Int ?? 0
                let likeCount = doc.data()[FirestoreKeys.BusinessCardFields.likeCount] as? Int ?? 0
                let description = doc.data()[FirestoreKeys.BusinessCardFields.description] as? String ?? ""
                let tags = (doc.data()[FirestoreKeys.BusinessCardFields.tags] as? [String])?.compactMap { ServiceTag(rawValue: $0) } ?? []
                let phoneNumber = doc.data()[FirestoreKeys.BusinessCardFields.phoneNumber] as? String
                let email = doc.data()[FirestoreKeys.BusinessCardFields.email] as? String
                let insta = doc.data()[FirestoreKeys.BusinessCardFields.insta] as? String
                
                return BusinessCard(id: doc.documentID, userID: userID, isActive: isActive, serviceType: serviceType, pricing: pricing, city: city, likeCount: likeCount, description: description, tags: tags, phoneNumber: phoneNumber, email: email, insta: insta)
            }
            return card
        } catch {
            print("fetch Business card error \(error)")
            return []
        }
    }
    
    func fetchAllActiveCards() async throws -> [BusinessCard] {
        
        let query: Query = db.collection(FirestoreKeys.Collections.businessCardFields)
            .whereField(FirestoreKeys.BusinessCardFields.isActive, isEqualTo: true)
        
        do {
            let snapshot = try await query.getDocuments()
            
            let card = snapshot.documents.compactMap { doc in
                let userID = doc.data()[FirestoreKeys.BusinessCardFields.userID] as? String ?? ""
                let isActive = doc.data()[FirestoreKeys.BusinessCardFields.isActive] as? Bool ?? false
                let city = doc.data()[FirestoreKeys.BusinessCardFields.city] as? String ?? ""
                let serviceType = ServiceType(rawValue:doc.data()[FirestoreKeys.BusinessCardFields.serviceType] as? String ?? "") ?? .stringing
                let pricing = doc.data()[FirestoreKeys.BusinessCardFields.pricing] as? Int ?? 0
                let likeCount = doc.data()[FirestoreKeys.BusinessCardFields.likeCount] as? Int ?? 0
                let description = doc.data()[FirestoreKeys.BusinessCardFields.description] as? String ?? ""
                let tags = (doc.data()[FirestoreKeys.BusinessCardFields.tags] as? [String])?.compactMap { ServiceTag(rawValue: $0) } ?? []
                let phoneNumber = doc.data()[FirestoreKeys.BusinessCardFields.phoneNumber] as? String
                let email = doc.data()[FirestoreKeys.BusinessCardFields.email] as? String
                let insta = doc.data()[FirestoreKeys.BusinessCardFields.insta] as? String
                
                return BusinessCard(id: doc.documentID, userID: userID, isActive: isActive, serviceType: serviceType, pricing: pricing, city: city, likeCount: likeCount, description: description, tags: tags, phoneNumber: phoneNumber, email: email, insta: insta)
            }
            return card
        } catch {
            print("Could not fetch cards (error: \(error))")
            return []
        }
    }
}
